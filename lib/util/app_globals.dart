import 'package:supabase_flutter/supabase_flutter.dart';

class AppGlobals {
  static final SupabaseClient supabase = Supabase.instance.client;

  static Session? get session => supabase.auth.currentSession;

  static String? get userId => session?.user.id;

  static String? get userRole => session?.user.userMetadata?['role'];
}
