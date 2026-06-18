import { LightningElement, wire } from 'lwc';
import {publish, MessageContext} from  'lightning/messageService';
import LOAN_CHANNEL from '@salesforce/messageChannel/LoanMessageChannel__c'; // messaging channel
import getAllLoans from '@salesforce/apex/LoanApplicationHelper.getAllLoans';
export default class LoanPublisher extends LightningElement {

    
    loanList = [];

    // this is required for communication with channel
    @wire(MessageContext)
    messageContext;

    columns = [
        {label:'Id',fieldName:'Id'},
        {label:'Loan Name',fieldName:'Name'},
        {
            type:'button',
            label:'Select',
            typeAttributes:{
                label:'Select',
                name:'select',
                variant:'brand'
            }
        }
    ];


    // Getting all loans
    @wire(getAllLoans)
    wiredLoan(result){
        if(result.data){
            this.loanList = result.data;
        }else if(result.error){
            console.log(result.error);
        }
    }


    handleRowAction(event){
        const row = event.detail.row;
        // Payload to share with channel
        const payload ={
            loanId: row.Id
        }

        //publish payload on channel
        publish(
            this.messageContext,
            LOAN_CHANNEL,
            payload
        );
    }




}