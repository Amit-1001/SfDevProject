public with sharing class EventSpeakersV1Dispatcher {
    public static void dispatch(System.TriggerOperation operationType) {
        switch on  operationType {
            when  BEFORE_INSERT {
                EventSpeakerV1Handler.handleDuplicateSpeaker(Trigger.new);
            }
            when  AFTER_INSERT {
                
            }
            when  BEFORE_UPDATE {
                EventSpeakerV1Handler.handleDuplicateSpeaker(Trigger.new);
            }
            when  AFTER_UPDATE {
                
            }
        }

    }
}