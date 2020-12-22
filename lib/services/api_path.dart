class APIPath {
  static String userDocument(String uid) => 'users/$uid';
  static String usersCollections() => 'users';

  static String messagesCollection(String groupeChatId) =>
      'conversations/$groupeChatId/messages';

  static String userImagesCollection(String uid) => 'users/$uid/profileImage';
}
