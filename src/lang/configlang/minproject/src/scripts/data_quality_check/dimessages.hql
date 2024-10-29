select MessageDateAndTime, BatchID, MessageSource, MessageText,
MessageType, MessageData from master.DImessages where MessageType <>
'Visibility' order by BatchId, MessageSource, MessageText, MessageData;