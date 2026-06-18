import getAllAccounts from '@salesforce/apex/AccountLWCHelper.getAllAccounts';
import { LightningElement , wire} from 'lwc';

export default class AccountData extends LightningElement {

    accountList;
    isLoading = false;
    columns = [
        { label: 'Account Name', fieldName: 'Name' },
        { label: 'Active', fieldName: 'Active__c' }
    ]


    @wire(getAllAccounts)
    wiredAccounts(result){
        
        if(result.data){
            this.accountList = result.data;
        } else if(result.error){
            this.accountList = undefined;
        }
        }

    get hasData(){
        return this.accountList && this.accountList.length > 0
    }
    
}



