import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { createRecord } from 'lightning/uiRecordApi';

//Object Schema
import LOAN_OBJECT from '@salesforce/schema/Loan_Application__c';

import LOAN_NAME from '@salesforce/schema/Loan_Application__c.Name';

import LOAN_AMOUNT from '@salesforce/schema/Loan_Application__c.Loan_Amount__c';

import LOAN_STATUS from '@salesforce/schema/Loan_Application__c.Status__c';

import LOAN_CUSTOMER from '@salesforce/schema/Loan_Application__c.Customer__c';

import { NavigationMixin } from 'lightning/navigation';

export default class LoanCreator extends NavigationMixin(LightningElement) {

    loanName = '';
    loanAmount ='';
    loanStatus = '';
    loanCustomer ='';

    isLoading = false;

    handleName(event){
        this.loanName = event.target.value;
    }

    handleAmount(event){
        this.loanAmount = event.target.value;
    }

    handleStatus(event){
        this.loanStatus = event.target.value;
    }

    handleCustomerSelect(event){

        this.loanCustomer = event.detail.recordId;
    }

    handleCreateLoan(){

        this.isLoading = true;
        const fields = {
            [LOAN_NAME.fieldApiName]: this.loanName,
            [LOAN_AMOUNT.fieldApiName]: this.loanAmount,
            [LOAN_STATUS.fieldApiName]: this.loanStatus,
            [LOAN_CUSTOMER.fieldApiName]: this.loanCustomer
        };

        const recordInput ={
            apiName:LOAN_OBJECT.objectApiName,
            fields
        }

        createRecord(recordInput)
        .then(result=>{
            this.dispatchEvent(
                new ShowToastEvent({
                    
                title : 'Success',

                message: 'Loan Created Successfully!',

                variant : 'success'
                })

                
            );

             // Reset Form
                this.loanName = '';

                this.loanAmount = '';

                this.loanStatus = '';

                this.loanCustomer = '';

                console.log('Results :', result);

                this[NavigationMixin.Navigate]({
                    type:'standard__recordPage',
                    attributes: {
                        recordId :result.id,
                        objectApiName: 'Loan_Application__c',
                        actionName: 'view'
                    }
                });


        })
        .catch(error=>{
            this.dispatchEvent(
                new ShowToastEvent({
                    title:'Error',
                    message: error,
                    variant: 'error'
                })

                
            )

            console.log('Error:'+JSON.stringify(error));
        })
        .finally(()=>{
            this.isLoading = false;
        })
        
    }




}