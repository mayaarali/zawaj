class EndPoints {
  static String BASE_URL = 'http://51.195.41.3:8080/api/';
  static String BASE_URL_image = 'http://51.195.41.3:8080/images/';
  static String signalRHub = 'http://51.195.41.3:8080/chat-hub?userId=';
  static String gifAPIKEY = 'Rrld39zcTX19uR6hWe3rpKbEyJ0njpKu';
  static const login = 'Account/Login';
  static const register = 'Account/Registration';
  static const confirmEmail = 'Account/ConfirmEmailByOtp';
  static const confirmPhone = 'Account/ConfirmPhoneByOtp';
  static const continueRegister = 'Account/CompleteRegistration';
  static const socialLogin = 'Account/SocialLogin';
  static const sendEmail = 'Account/ForgetPasswordByOtp';
  static const checkOtp = 'Account/CheckOtp';
  static const resetPassword = 'Account/ResetPassword';
  static const logout = 'Account/SignedOut';

  static const setup_params =
      'HomeUser/GetPersonalParametersWithValues?lang=ar';
  static const get_City = 'HomeUser/GetAllCity';
  static const get_Area = 'HomeUser/GetAllArea';
  static const post_Setup = 'HomeUser/AccountSetup';
  static const update_Setup = 'HomeUser/UpdateAccountSetup?lang=ar';
  static const post_required = 'HomeUser/AddReuiredSpecifications';
  static const addFeedbackApplication = 'HomeUser/AddFeedbackApplication';
  static const toggleNotificationApp = 'HomeUser/ToggleNotificationApp';
  static const toggleLike = 'HomeUser/ToggleLike';
  static const convertFile = 'HomeUser/ConvertFile';
  static const toglleMessage = 'HomeUser/ToggleMessage';
  static const aboutMe = 'HomeUser/AddAbout';
  static const profile_data = 'HomeUser/GetProfile?lang=ar';
  static const profile_partner = 'HomeUser/GetRequiredSpecification?lang=ar';
  static const send_report = 'HomeUser/AddFeedbackUsers';
  static const remove_user = 'HomeUser/RemoveUser';
  static const get_partner_data =
      'homeUser/GetMatching?Page=1&PagesLimit=10&lang=ar';
  static const LikedPost = 'HomeUser/LikeUser';
  static const disLikePost = 'HomeUser/DisLikeUser';
  static const likedPartners =
      'HomeUser/GetMatchingLiked?Page=1&PagesLimit=10&lang=ar';

  static const hubURL = '51.195.41.3/chat-hub';
  static const sendMessage = 'Chat/SendMessage';
  static const appReport = 'HomeUser/AddFeedbackApplication';
  static const whoLikedMe = 'HomeUser/GetWhoLikedMe';
  static const verification = 'HomeUser/AddVerification';
  static const updatePartnerDetails =
      'HomeUser/UpdateRequiredSpecifications?lang=ar';
  static const deleteAccount = 'HomeUser/DeleteUser';
  static const getPaymentPlans = 'Payment/GetAllPaymentPlains';
  static const getStandardPaymentValue = 'Payment/GetStandardValue';
  static const postPaymentPlans = 'Payment/GeneratePaymentLink';
  static const verifyPayment = 'Payment/VerifyPayment';
  static const getConsultant = 'Consultant/GetAllConsultants';

  static const clickConsultant = 'Consultant/ClickOnConsultant';

  static const getNotifications = 'Notification/GetAllNotifications';
}
