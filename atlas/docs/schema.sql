-- Atlas Database Schema
-- PostgreSQL

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email VARCHAR(255) UNIQUE,
    -- 改动1: 加一个登录密码和用户所在地，初始界面默认显示用户所在地附近的地点
    password_hash TEXT,
    location VARCHAR(100),
    display_name VARCHAR(255),
    avatar_url TEXT,
    auth_provider VARCHAR(50),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE places (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    created_by UUID REFERENCES users(id) ON DELETE SET NULL,
    name VARCHAR(255) NOT NULL,
    subtitle VARCHAR(255),
    description TEXT,
    ai_summary TEXT,
    category VARCHAR(100),
    address TEXT,
    city VARCHAR(100),
    region VARCHAR(100),
    country VARCHAR(100),
    latitude DECIMAL(10, 7),
    longitude DECIMAL(10, 7),
    external_place_id VARCHAR(255),
    external_source VARCHAR(100),
    visibility VARCHAR(50) DEFAULT 'private',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    -- 改动2: 加一个tag，每个地理位置可选有相关的tag（比如 cafe, restaurant, museum）
    tags TEXT

);

CREATE TABLE place_sources (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    place_id UUID REFERENCES places(id) ON DELETE CASCADE,
    user_id UUID REFERENCES users(id) ON DELETE SET NULL,
    source_type VARCHAR(100),
    source_url TEXT,
    raw_text TEXT,
    screenshot_url TEXT,
    ai_extracted_summary TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE collections (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    owner_id UUID REFERENCES users(id) ON DELETE CASCADE,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    visibility VARCHAR(50) DEFAULT 'private',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE collection_places (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    collection_id UUID REFERENCES collections(id) ON DELETE CASCADE,
    place_id UUID REFERENCES places(id) ON DELETE CASCADE,
    added_by UUID REFERENCES users(id) ON DELETE SET NULL,
    note TEXT,
    sort_order INT DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE (collection_id, place_id)
);

CREATE TABLE projects (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    owner_id UUID REFERENCES users(id) ON DELETE CASCADE,
    title VARCHAR(255) NOT NULL,
    destination VARCHAR(255),
    start_date DATE,
    end_date DATE,
    description TEXT,
    visibility VARCHAR(50) DEFAULT 'private',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE project_members (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    project_id UUID REFERENCES projects(id) ON DELETE CASCADE,
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    role VARCHAR(50) DEFAULT 'member',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE (project_id, user_id)
);

CREATE TABLE project_places (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    project_id UUID REFERENCES projects(id) ON DELETE CASCADE,
    place_id UUID REFERENCES places(id) ON DELETE CASCADE,
    added_by UUID REFERENCES users(id) ON DELETE SET NULL,
    status VARCHAR(50) DEFAULT 'saved',
    note TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE (project_id, place_id)
);

CREATE TABLE itinerary_days (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    project_id UUID REFERENCES projects(id) ON DELETE CASCADE,
    date DATE,
    title VARCHAR(255),
    sort_order INT DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE itinerary_items (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    itinerary_day_id UUID REFERENCES itinerary_days(id) ON DELETE CASCADE,
    place_id UUID REFERENCES places(id) ON DELETE SET NULL,
    start_time TIME,
    end_time TIME,
    note TEXT,
    sort_order INT DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE imports (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    project_id UUID REFERENCES projects(id) ON DELETE SET NULL,
    collection_id UUID REFERENCES collections(id) ON DELETE SET NULL,
    input_type VARCHAR(100),
    input_url TEXT,
    input_text TEXT,
    file_url TEXT,
    status VARCHAR(50) DEFAULT 'pending',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE extracted_places (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    import_id UUID REFERENCES imports(id) ON DELETE CASCADE,
    name VARCHAR(255),
    address TEXT,
    city VARCHAR(100),
    country VARCHAR(100),

    -- 改动3.1：用 PostGIS 的 geography 类型来存储地理位置，支持更快的地理信息查询
    -- latitude DECIMAL(10, 7),
    -- longitude DECIMAL(10, 7),
    location GEOGRAPHY(POINT, 4326) NOT NULL,

    ai_summary TEXT,
    confidence DECIMAL(4, 3),
    status VARCHAR(50) DEFAULT 'pending',
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 改动3.2: 用 PostGIS 扩展为 places 表的 location 字段创建 GiST 索引，优化地理位置查询性能
CREATE EXTENSION IF NOT EXISTS postgis;
CREATE INDEX idx_places_location_gist ON places USING GIST(location);

CREATE TABLE chat_sessions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    project_id UUID REFERENCES projects(id) ON DELETE SET NULL,
    title VARCHAR(255),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE chat_messages (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    chat_session_id UUID REFERENCES chat_sessions(id) ON DELETE CASCADE,
    sender_type VARCHAR(50),
    content TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    -- 改动4: 新增一个本chat提取出的地点
    extracted_places JSONB,   
    -- 改动5: 新增一个本chat消耗的token，方便之后计算成本，还有后续开发，或者区分免费/订阅付费功能        
    metadata JSONB,
);

CREATE TABLE user_place_interactions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    place_id UUID REFERENCES places(id) ON DELETE CASCADE,
    interaction_type VARCHAR(100),
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 改动6: 所有TIMESTAMP更换成TIMESTAMPTZ，避免时区混乱导致的时间戳错误
-- 改动7:maybe subscriptions table

-- Helpful indexes

CREATE INDEX idx_places_created_by ON places(created_by);
CREATE INDEX idx_places_location ON places(latitude, longitude);
CREATE INDEX idx_places_category ON places(category);

CREATE INDEX idx_place_sources_place_id ON place_sources(place_id);
CREATE INDEX idx_place_sources_user_id ON place_sources(user_id);

CREATE INDEX idx_collections_owner_id ON collections(owner_id);
CREATE INDEX idx_collection_places_collection_id ON collection_places(collection_id);
CREATE INDEX idx_collection_places_place_id ON collection_places(place_id);

CREATE INDEX idx_projects_owner_id ON projects(owner_id);
CREATE INDEX idx_project_members_project_id ON project_members(project_id);
CREATE INDEX idx_project_members_user_id ON project_members(user_id);
CREATE INDEX idx_project_places_project_id ON project_places(project_id);
CREATE INDEX idx_project_places_place_id ON project_places(place_id);

CREATE INDEX idx_imports_user_id ON imports(user_id);
CREATE INDEX idx_imports_status ON imports(status);
CREATE INDEX idx_extracted_places_import_id ON extracted_places(import_id);

CREATE INDEX idx_chat_sessions_user_id ON chat_sessions(user_id);
CREATE INDEX idx_chat_messages_session_id ON chat_messages(chat_session_id);

CREATE INDEX idx_user_place_interactions_user_id ON user_place_interactions(user_id);
CREATE INDEX idx_user_place_interactions_place_id ON user_place_interactions(place_id);
