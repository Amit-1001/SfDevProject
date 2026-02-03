public with sharing class RoundRobin {
    public static Id getNextUserId() {
        // Get 10 active users
        List<User> users = [
            SELECT Id 
            FROM User 
            WHERE IsActive = true 
            LIMIT 10
        ];

        // Fallback if no users
        if (users.isEmpty()) {
            return UserInfo.getUserId();
        }

        // Pointer (replace this with Custom Setting/Metadata for persistence)
        Integer pointer = 0;

        // Ensure pointer is always valid
        Integer index = Math.mod(pointer, users.size());

        // Return User Id
        return users[index].Id;
    }
}