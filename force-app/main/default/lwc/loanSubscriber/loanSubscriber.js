import { LightningElement,wire } from 'lwc';

import { subscribe,MessageContext } from 'lightning/messageService';

import LOAN_CHANNEL from '@salesforce/messageChannel/LoanMessageChannel__c';

export default class LoanSubscriber extends LightningElement {

    subscription  = null;
    selectedLoanId;


    @wire(MessageContext)
    messageContext;

    connectedCallback(){

        this.subscribeToMessageChannel();
    }

    subscribeToMessageChannel(){
        if(!this.subscription ){
        this.subscription =  subscribe(
                this.messageContext,
                LOAN_CHANNEL,
                (message)=> this.handleMessage(message) // we are forwarding received message to funtion
            )
        }
    }

    handleMessage(message){
        this.selectedLoanId = message.loanId;
    }


}