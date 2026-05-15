import { api, LightningElement, wire } from 'lwc';
import getPendingLoans from '@salesforce/apex/LoanApplicationHelper.getPendingLoans';
import approveLoan from '@salesforce/apex/LoanApplicationHelper.approveLoan';
import rejectLoan from '@salesforce/apex/LoanApplicationHelper.rejectLoan';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import { refreshApex } from '@salesforce/apex'; // Needed to refresh @wire


export default class LoanApprover extends LightningElement {

    

    isLoading = false;

    loanList;

    wiredResult;

    @wire(getPendingLoans)
    wiredLoans(result){
        this.wiredResult = result;
        if(result.data){
            this.loanList = result.data;
        }else if(result.error){
            console.error(result.error);
        }
    }

    handleApproveClick(event){
        this.isLoading =true;

        approveLoan({recordId:event.target.dataset.id})
        .then(result=>{
            this.dispatchEvent(
                new ShowToastEvent({
                    title:'Success',
                    message: result,
                    variant: 'success'
                })
            );
            return refreshApex(this.wiredResult); // refreshing content
        })
        .catch(error=>{
            this.dispatchEvent(
                new ShowToastEvent({
                    title:'Error',
                    message: error.body.message,
                    variant: 'error'
                })
            );
        })
        .finally(()=>{
            this.isLoading = false // disabling spinner again
        })
    }

    handleRejectClick(event){
        this.isLoading =true;

        rejectLoan({recordId:event.target.dataset.id})
        .then(result=>{
            this.dispatchEvent(
                new ShowToastEvent({
                    title:'Success',
                    message: result,
                    variant: 'success'
                })
            );
            return refreshApex(this.wiredResult); // refreshing content
        })
        .catch(error=>{
            this.dispatchEvent(
                new ShowToastEvent({
                    title:'Error',
                    message: error.body.message,
                    variant: 'error'
                })
            );
        })
        .finally(()=>{
            this.isLoading = false // disabling spinner again
        })
    }
    

}