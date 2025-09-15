import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': {

      // Common
      'app_name': 'Movers App',
      'welcome': 'Welcome',
      'next': 'Next',
      'previous': 'Previous',
      'skip': 'Skip',
      'get_started': 'Get Started',
      'continue': 'Continue',
      'done': 'Done',
      'success': 'Success',
      'error': 'Error',
      'overview': 'Overview',
      'quick_actions': 'Quick Actions',
      'recent_activity': 'Recent Activity',
      'view_all': 'View All',

      // Onboarding
      'onboarding_title_1': 'Move with Confidence',
      'onboarding_subtitle_1':
      'Find trusted movers and transport services for your cargo, parcels, and personal items.',
      'onboarding_title_2': 'Smart Bidding System',
      'onboarding_subtitle_2':
      'Get competitive quotes from multiple service providers and choose the best deal.',
      'onboarding_title_3': 'Real-time Tracking',
      'onboarding_subtitle_3':
      'Track your shipments in real-time and stay updated on delivery status.',

      // Splash
      'loading': 'Loading...',
      'initializing': 'Initializing...',
// For LoadCard translations
      'tr_fixed': 'Fixed',
      'tr_per_tonne': '/Tonne',
      'tr_pickup': 'Pickup',
      'tr_drop': 'Drop',
      'tr_created': 'Created',
      'tr_today': 'today',
      'tr_yesterday': 'yesterday',
      'tr_days_ago': '{days} days ago',
      'tr_confirmed': 'Confirmed',
      'tr_cancelled': 'Cancelled',
      // Auth
      'sign_in': 'Sign In',
      'sign_up': 'Sign Up',
      'create_account': 'Create Account',
      'already_have_account': 'Already have an account? Sign In',
      'email': 'Email',
      'password': 'Password',
      'confirm_password': 'Confirm Password',
      'full_name': 'Full Name',
      'phone_number': 'Phone Number (Optional)',
      'remember_me': 'Remember Me',
      'forgot_password': 'Forgot Password?',
      'sign_in_with_google': 'Sign In with Google',
      'sign_up_with_google': 'Sign Up with Google',
      'accept_terms': 'I accept the Terms and Conditions',
      'terms_required': 'Terms Required',
      'privacy_policy': 'Privacy Policy',
      'password_strength': 'Password Strength',
      'weak': 'Weak',
      'medium': 'Medium',
      'strong': 'Strong',
      'email_required': 'Email is required',
      'invalid_email': 'Please enter a valid email',
      'password_required': 'Password is required',
      'password_too_short': 'Password must be at least 6 characters',
      'full_name_required': 'Full name is required',
      'full_name_too_short': 'Full name must be at least 2 characters',
      'invalid_full_name': 'Full name can only contain letters and spaces',
      'invalid_phone': 'Please enter a valid phone number',
      'password_min_length': 'Password must be at least 8 characters',
      'password_uppercase':
      'Password must contain at least one uppercase letter',
      'password_lowercase':
      'Password must contain at least one lowercase letter',
      'password_number': 'Password must contain at least one number',
      'confirm_password_required': 'Please confirm your password',
      'passwords_do_not_match': 'Passwords do not match',
      'terms_conditions_message':
      'Please accept the terms and conditions to continue',
      'sign_in_success': 'Welcome back!',
      'sign_up_success':
      'Welcome! Please check your email to verify your account.',
      'sign_out_success': 'Signed out successfully',

      // Stats
      'total_loads': 'Total Loads',
      'active_rides': 'Active Rides',
      'pending_parcels': 'Pending Parcels',
      'total_earnings': 'Total Earnings',

      // Quick Actions
      'book_new_load': 'Book New Load',
      'track_shipment': 'Track Shipment',
      'view_quotes': 'View Quotes',
      'manage_profile': 'Manage Profile',

      // Recent Activity
      'shipment_delivered': 'Shipment Delivered',
      'ride_completed': 'Ride Completed',
      'quote_accepted': 'Quote Accepted',
      'status_pending': 'Pending',
      'status_in_progress': 'In Progress',
      'status_completed': 'Completed',
    },
    'ar_SA': {
      // Common
      'app_name': 'تطبيق الموفرز',
      'welcome': 'مرحباً',
      'next': 'التالي',
      'previous': 'السابق',
      'skip': 'تخطى',
      'get_started': 'ابدأ',
      'continue': 'متابعة',
      'done': 'تم',
      'success': 'نجاح',
      'error': 'خطأ',
      'overview': 'نظرة عامة',
      'quick_actions': 'إجراءات سريعة',
      'recent_activity': 'النشاط الأخير',
      'view_all': 'عرض الكل',

      // Onboarding
      'onboarding_title_1': 'تحرك بثقة',
      'onboarding_subtitle_1':
      'ابحث عن خدمات نقل وتوصيل موثوقة للبضائع والطرود وأغراضك الشخصية.',
      'onboarding_title_2': 'نظام عروض ذكي',
      'onboarding_subtitle_2':
      'احصل على عروض تنافسية من مقدمي خدمات متعددين واختر أفضل صفقة.',
      'onboarding_title_3': 'تتبع في الوقت الفعلي',
      'onboarding_subtitle_3':
      'تتبع شحناتك في الوقت الفعلي وابقَ على اطلاع بحالة التوصيل.',

      // Splash
      'loading': 'جارٍ التحميل...',
      'initializing': 'جارٍ التهيئة...',

      // Auth
      'sign_in': 'تسجيل الدخول',
      'sign_up': 'إنشاء حساب',
      'create_account': 'إنشاء حساب',
      'already_have_account': 'لديك حساب بالفعل؟ تسجيل الدخول',
      'email': 'البريد الإلكتروني',
      'password': 'كلمة المرور',
      'confirm_password': 'تأكيد كلمة المرور',
      'full_name': 'الاسم الكامل',
      'phone_number': 'رقم الهاتف (اختياري)',
      'remember_me': 'تذكرني',
      'forgot_password': 'نسيت كلمة المرور؟',
      'sign_in_with_google': 'تسجيل الدخول باستخدام جوجل',
      'sign_up_with_google': 'إنشاء حساب باستخدام جوجل',
      'accept_terms': 'أوافق على الشروط والأحكام',
      'terms_required': 'الموافقة على الشروط مطلوبة',
      'privacy_policy': 'سياسة الخصوصية',
      'password_strength': 'قوة كلمة المرور',
      'weak': 'ضعيف',
      'medium': 'متوسط',
      'strong': 'قوي',
      'email_required': 'البريد الإلكتروني مطلوب',
      'invalid_email': 'الرجاء إدخال بريد إلكتروني صالح',
      'password_required': 'كلمة المرور مطلوبة',
      'password_too_short': 'يجب أن تكون كلمة المرور 6 أحرف على الأقل',
      'full_name_required': 'الاسم الكامل مطلوب',
      'full_name_too_short': 'يجب أن يكون الاسم الكامل حرفين على الأقل',
      'invalid_full_name': 'يجب أن يحتوي الاسم الكامل على أحرف ومسافات فقط',
      'invalid_phone': 'الرجاء إدخال رقم هاتف صالح',
      'password_min_length': 'يجب أن تكون كلمة المرور 8 أحرف على الأقل',
      'password_uppercase':
      'يجب أن تحتوي كلمة المرور على حرف كبير واحد على الأقل',
      'password_lowercase':
      'يجب أن تحتوي كلمة المرور على حرف صغير واحد على الأقل',
      'password_number': 'يجب أن تحتوي كلمة المرور على رقم واحد على الأقل',
      'confirm_password_required': 'الرجاء تأكيد كلمة المرور',
      'passwords_do_not_match': 'كلمتا المرور غير متطابقتين',
      'terms_conditions_message': 'الرجاء قبول الشروط والأحكام للمتابعة',
      'sign_in_success': 'مرحباً بعودتك!',
      'sign_up_success':
      'مرحباً! الرجاء التحقق من بريدك الإلكتروني لتفعيل حسابك.',
      'sign_out_success': 'تم تسجيل الخروج بنجاح',

      // Stats
      'total_loads': 'إجمالي الأحمال',
      'active_rides': 'الرحلات النشطة',
      'pending_parcels': 'الطرود المعلقة',
      'total_earnings': 'إجمالي الأرباح',

      // Quick Actions
      'book_new_load': 'حجز حمولة جديدة',
      'track_shipment': 'تتبع الشحنة',
      'view_quotes': 'عرض العروض',
      'manage_profile': 'إدارة الملف الشخصي',

      // Recent Activity
      'shipment_delivered': 'تم تسليم الشحنة',
      'ride_completed': 'تم إكمال الرحلة',
      'quote_accepted': 'تم قبول العرض',
      'status_pending': 'معلق',
      'status_in_progress': 'قيد التقدم',
      'status_completed': 'مكتمل',
    },
    'fr_FR': {
      // Common
      'app_name': 'Application Movers',
      'welcome': 'Bienvenue',
      'next': 'Suivant',
      'previous': 'Précédent',
      'skip': 'Passer',
      'get_started': 'Commencer',
      'continue': 'Continuer',
      'done': 'Terminé',
      'success': 'Succès',
      'error': 'Erreur',
      'overview': 'Aperçu',
      'quick_actions': 'Actions rapides',
      'recent_activity': 'Activité récente',
      'view_all': 'Voir tout',

      // Onboarding
      'onboarding_title_1': 'Déplacez-vous en toute confiance',
      'onboarding_subtitle_1':
      'Trouvez des services de déménagement et de transport fiables pour vos marchandises, colis et objets personnels.',
      'onboarding_title_2': 'Système d\'enchères intelligent',
      'onboarding_subtitle_2':
      'Obtenez des devis compétitifs de plusieurs prestataires de services et choisissez la meilleure offre.',
      'onboarding_title_3': 'Suivi en temps réel',
      'onboarding_subtitle_3':
      'Suivez vos expéditions en temps réel et restez informé de l\'état de la livraison.',

      // Splash
      'loading': 'Chargement...',
      'initializing': 'Initialisation...',

      // Auth
      'sign_in': 'Se connecter',
      'sign_up': 'S\'inscrire',
      'create_account': 'Créer un compte',
      'already_have_account': 'Vous avez déjà un compte ? Connectez-vous',
      'email': 'Email',
      'password': 'Mot de passe',
      'confirm_password': 'Confirmer le mot de passe',
      'full_name': 'Nom complet',
      'phone_number': 'Numéro de téléphone (facultatif)',
      'remember_me': 'Se souvenir de moi',
      'forgot_password': 'Mot de passe oublié ?',
      'sign_in_with_google': 'Se connecter avec Google',
      'sign_up_with_google': 'S\'inscrire avec Google',
      'accept_terms': 'J\'accepte les conditions générales',
      'terms_required': 'Acceptation des conditions requise',
      'privacy_policy': 'Politique de confidentialité',
      'password_strength': 'Force du mot de passe',
      'weak': 'Faible',
      'medium': 'Moyen',
      'strong': 'Fort',
      'email_required': 'L\'email est requis',
      'invalid_email': 'Veuillez entrer un email valide',
      'password_required': 'Le mot de passe est requis',
      'password_too_short': 'Le mot de passe doit contenir au moins 6 caractères',
      'full_name_required': 'Le nom complet est requis',
      'full_name_too_short': 'Le nom complet doit contenir au moins 2 caractères',
      'invalid_full_name':
      'Le nom complet ne peut contenir que des lettres et des espaces',
      'invalid_phone': 'Veuillez entrer un numéro de téléphone valide',
      'password_min_length': 'Le mot de passe doit contenir au moins 8 caractères',
      'password_uppercase':
      'Le mot de passe doit contenir au moins une lettre majuscule',
      'password_lowercase':
      'Le mot de passe doit contenir au moins une lettre minuscule',
      'password_number': 'Le mot de passe doit contenir au moins un chiffre',
      'confirm_password_required': 'Veuillez confirmer votre mot de passe',
      'passwords_do_not_match': 'Les mots de passe ne correspondent pas',
      'terms_conditions_message':
      'Veuillez accepter les conditions générales pour continuer',
      'sign_in_success': 'Bienvenue de retour !',
      'sign_up_success':
      'Bienvenue ! Veuillez vérifier votre email pour activer votre compte.',
      'sign_out_success': 'Déconnexion réussie',

      // Stats
      'total_loads': 'Total des chargements',
      'active_rides': 'Courses actives',
      'pending_parcels': 'Colis en attente',
      'total_earnings': 'Gains totaux',

      // Quick Actions
      'book_new_load': 'Réserver un nouveau chargement',
      'track_shipment': 'Suivre l\'expédition',
      'view_quotes': 'Voir les devis',
      'manage_profile': 'Gérer le profil',

      // Recent Activity
      'shipment_delivered': 'Expédition livrée',
      'ride_completed': 'Course terminée',
      'quote_accepted': 'Devis accepté',
      'status_pending': 'En attente',
      'status_in_progress': 'En cours',
      'status_completed': 'Terminé',
    },
    'es_ES': {
      // Common
      'app_name': 'Aplicación Movers',
      'welcome': 'Bienvenido',
      'next': 'Siguiente',
      'previous': 'Anterior',
      'skip': 'Omitir',
      'get_started': 'Comenzar',
      'continue': 'Continuar',
      'done': 'Hecho',
      'success': 'Éxito',
      'error': 'Error',
      'overview': 'Resumen',
      'quick_actions': 'Acciones rápidas',
      'recent_activity': 'Actividad reciente',
      'view_all': 'Ver todo',

      // Onboarding
      'onboarding_title_1': 'Muévete con confianza',
      'onboarding_subtitle_1':
      'Encuentra servicios de mudanza y transporte confiables para tus mercancías, paquetes y objetos personales.',
      'onboarding_title_2': 'Sistema de pujas inteligente',
      'onboarding_subtitle_2':
      'Obtén cotizaciones competitivas de múltiples proveedores de servicios y elige la mejor oferta.',
      'onboarding_title_3': 'Seguimiento en tiempo real',
      'onboarding_subtitle_3':
      'Sigue tus envíos en tiempo real y mantente actualizado sobre el estado de la entrega.',

      // Splash
      'loading': 'Cargando...',
      'initializing': 'Inicializando...',

      // Auth
      'sign_in': 'Iniciar sesión',
      'sign_up': 'Registrarse',
      'create_account': 'Crear cuenta',
      'already_have_account': '¿Ya tienes una cuenta? Inicia sesión',
      'email': 'Correo electrónico',
      'password': 'Contraseña',
      'confirm_password': 'Confirmar contraseña',
      'full_name': 'Nombre completo',
      'phone_number': 'Número de teléfono (opcional)',
      'remember_me': 'Recuérdame',
      'forgot_password': '¿Olvidaste tu contraseña?',
      'sign_in_with_google': 'Iniciar sesión con Google',
      'sign_up_with_google': 'Registrarse con Google',
      'accept_terms': 'Acepto los términos y condiciones',
      'terms_required': 'Se requiere aceptar los términos',
      'privacy_policy': 'Política de privacidad',
      'password_strength': 'Fuerza de la contraseña',
      'weak': 'Débil',
      'medium': 'Media',
      'strong': 'Fuerte',
      'email_required': 'El correo electrónico es requerido',
      'invalid_email': 'Por favor, introduce un correo electrónico válido',
      'password_required': 'La contraseña es requerida',
      'password_too_short': 'La contraseña debe tener al menos 6 caracteres',
      'full_name_required': 'El nombre completo es requerido',
      'full_name_too_short': 'El nombre completo debe tener al menos 2 caracteres',
      'invalid_full_name':
      'El nombre completo solo puede contener letras y espacios',
      'invalid_phone': 'Por favor, introduce un número de teléfono válido',
      'password_min_length': 'La contraseña debe tener al menos 8 caracteres',
      'password_uppercase':
      'La contraseña debe contener al menos una letra mayúscula',
      'password_lowercase':
      'La contraseña debe contener al menos una letra minúscula',
      'password_number': 'La contraseña debe contener al menos un número',
      'confirm_password_required': 'Por favor, confirma tu contraseña',
      'passwords_do_not_match': 'Las contraseñas no coinciden',
      'terms_conditions_message':
      'Por favor, acepta los términos y condiciones para continuar',
      'sign_in_success': '¡Bienvenido de vuelta!',
      'sign_up_success':
      '¡Bienvenido! Por favor, verifica tu correo electrónico para activar tu cuenta.',
      'sign_out_success': 'Cierre de sesión exitoso',

      // Stats
      'total_loads': 'Cargas totales',
      'active_rides': 'Viajes activos',
      'pending_parcels': 'Paquetes pendientes',
      'total_earnings': 'Ganancias totales',

      // Quick Actions
      'book_new_load': 'Reservar nueva carga',
      'track_shipment': 'Rastrear envío',
      'view_quotes': 'Ver cotizaciones',
      'manage_profile': 'Administrar perfil',

      // Recent Activity
      'shipment_delivered': 'Envío entregado',
      'ride_completed': 'Viaje completado',
      'quote_accepted': 'Cotización aceptada',
      'status_pending': 'Pendiente',
      'status_in_progress': 'En progreso',
      'status_completed': 'Completado',
    },
  };
}