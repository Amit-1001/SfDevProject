public class AccountTriggerDispatcher {
    
    public static void runDispatcher(System.TriggerOperation operationType){
        // Trigger.OperationType = System.TriggerOperation 
        Switch on operationType{
            when BEFORE_INSERT, BEFORE_UPDATE{ 
                // Before insert or update: Set Industry to 'Other' if null
                AccountTriggerHelper.updateAccountIndustry(Trigger.New);
                AccountTriggerHelper.duplicateCheck(Trigger.New); // check for duplicate record
            }
            when AFTER_INSERT{
                // After insert: Create a Task related to the new Account
                AccountTriggerHelper.CreateTaskOnAccount(Trigger.New);
			}
        }
    }

}