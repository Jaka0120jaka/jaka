package model;

import java.sql.Timestamp;

public class ChatMessage {
    private int messageId;
    private int roomId;
    private String senderId;
    private String message;
    private Timestamp sentAt;

    public ChatMessage(int messageId, int roomId, String senderId, String message, Timestamp sentAt) {
        this.messageId = messageId;
        this.roomId = roomId;
        this.senderId = senderId;
        this.message = message;
        this.sentAt = sentAt;
    }
    
    public int getMessageId() { return messageId; }
    public int getRoomId() { return roomId; }
    public String getSenderId() { return senderId; }
    public String getMessage() { return message; }
    public Timestamp getSentAt() { return sentAt; }
}
