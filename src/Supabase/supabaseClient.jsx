// src/supabaseClient.js
import { createClient } from '@supabase/supabase-js';

export const supabase = createClient('https://ywtvzqvvjzzpkbduddux.supabase.co', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inl3dHZ6cXZ2anp6cGtiZHVkZHV4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTU2MDE4NjUsImV4cCI6MjAzMTE3Nzg2NX0.vnqRDAVv6i5FQwYnAx8BiXufAPqgmtvcC6uAhxJIwmw');

/* const supabaseUrl = 'https://ywtvzqvvjzzpkbduddux.supabase.co';
const supabaseKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inl3dHZ6cXZ2anp6cGtiZHVkZHV4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTU2MDE4NjUsImV4cCI6MjAzMTE3Nzg2NX0.vnqRDAVv6i5FQwYnAx8BiXufAPqgmtvcC6uAhxJIwmw';

export const supabase = createClient(supabaseUrl, supabaseKey); */
