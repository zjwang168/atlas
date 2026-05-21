//
//  SupabaseClient.swift
//  atlas
//
//  Created by Zijin Wang on 5/21/26.
//

import Foundation
import Supabase

let supabase = SupabaseClient(
    supabaseURL: URL(string: "https://chhozwqwliktnkhvwtpc.supabase.co"
)!,
    supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNoaG96d3F3bGlrdG5raHZ3dHBjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzkzNTIxNzgsImV4cCI6MjA5NDkyODE3OH0.n-UECj5IvrZcy7tjyg4dYHGlVK8DJeoE5ZgKCF5nAMk"

)
