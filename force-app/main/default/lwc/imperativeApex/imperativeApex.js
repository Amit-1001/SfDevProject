import { api, LightningElement,wire } from 'lwc';
import getLoanApplicationByName from '@salesforce/apex/LoanApplicationHelper.getLoanApplicationByName'

import updateLoanStatus from '@salesforce/apex/LoanApplicationHelper.updateLoanStatus';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import { refreshApex } from '@salesforce/apex'; // Needed to refresh @wire

export default class ImperativeApex extends LightningElement {

    @api 
    recordId; // automatically store current recordId of record from record page

    loanApplication;

    isLoading = false;
    wiredResult; // Store this to refresh later

    @wire(getLoanApplicationByName,{recordId:'$recordId'})
    wiredLoanFunction(result) {
        this.wiredResult = result; // Keep a reference for refreshApex
        if (result.data) {
            this.loanApplication = result.data;
        } else if (result.error) {
            console.error(result.error);
        }
    }

    handleClick() {
        this.isLoading = true;

        updateLoanStatus({recordId : this.recordId})

        .then(result =>{
            this.dispatchEvent(
                new ShowToastEvent({
                title:'success',
                message:result,
                variant:'success'
            })
            
        );
         // CRITICAL: This updates the UI with the new status
            return refreshApex(this.wiredResult); 
        })
        .catch(error =>{
            this.dispatchEvent(
                new ShowToastEvent({
                title:'error',
                message:error.body.message,
                variant:'error'
            }));
        })
        .finally(()=>{
            this.isLoading = false;
        })
        
    }



}