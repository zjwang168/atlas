# Atlas ER Mapping

## 1. User Entity

A user can:
- create places
- create collections
- create projects
- import content
- interact with places
- participate in chats

Relationship mappings:
- User 1 --- N Places
- User 1 --- N Collections
- User 1 --- N Projects
- User 1 --- N Imports
- User 1 --- N ChatSessions

---

## 2. Place Entity

A place represents a saved location, restaurant, activity, or destination.

A place can:
- belong to multiple collections
- belong to multiple projects
- originate from imported content
- contain AI-generated summaries
- receive user interactions

Relationship mappings:
- Place N --- N Collections
- Place N --- N Projects
- Place 1 --- N PlaceSources
- Place 1 --- N UserInteractions

Implemented through:
- collection_places
- project_places

---

## 3. Collection Entity

Collections are lightweight saved folders.

Examples:
- NYC Cafes
- Tokyo Ramen
- Summer Food List

Relationship mappings:
- Collection N --- N Places

Implemented through:
- collection_places

---

## 4. Project Entity

Projects are structured travel plans.

Examples:
- Japan Trip 2026
- NYC Weekend
- Korea Food Tour

Projects can:
- contain places
- contain itinerary days
- contain itinerary items
- contain chat sessions
- have multiple members

Relationship mappings:
- Project N --- N Places
- Project 1 --- N ItineraryDays
- Project 1 --- N ChatSessions
- Project 1 --- N Imports
- Project N --- N Users

Implemented through:
- project_places
- project_members

---

## 5. Import Entity

Imports represent content brought into the app.

Supported inputs:
- links
- screenshots
- pasted text
- social media posts

Imports can generate:
- extracted places
- AI summaries
- metadata

Relationship mappings:
- Import 1 --- N ExtractedPlaces

---

## 6. Chat System

Chat sessions support AI-native workflows.

Examples:
- generate itinerary
- ask about saved places
- plan routes
- summarize imported content

Relationship mappings:
- ChatSession 1 --- N ChatMessages

---

## 7. Itinerary System

Projects can contain day-by-day itinerary structures.

Relationship mappings:
- Project 1 --- N ItineraryDays
- ItineraryDay 1 --- N ItineraryItems
- ItineraryItem N --- 1 Place

---

## 8. User Interaction Tracking

Tracks:
- saves
- views
- clicks
- AI recommendations
- engagement

Relationship mappings:
- User 1 --- N UserPlaceInteractions
- Place 1 --- N UserPlaceInteractions
