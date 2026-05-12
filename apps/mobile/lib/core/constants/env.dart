class Env {
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://uazgantmrlvrckqouqvn.supabase.co',
  );
  
  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVhemdhbnRtcmx2cmNrcW91cXZuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzg1Mjg1MjgsImV4cCI6MjA5NDEwNDUyOH0.BG87ZsWPEJZZO63xHcWkZbleg6zmDlPB4jqcP9jOEj4',
  );
}
