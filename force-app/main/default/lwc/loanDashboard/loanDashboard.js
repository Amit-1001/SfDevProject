import { LightningElement,wire } from 'lwc';

import getPendingLoans from '@salesforce/apex/LoanApplicationHelper.getPendingLoans';
import approveLoan from '@salesforce/apex/LoanApplicationHelper.approveLoan';
import rejectLoan from '@salesforce/apex/LoanApplicationHelper.rejectLoan';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import { refreshApex } from '@salesforce/apex'; // Needed to refresh @wire

export default class LoanDashboard extends LightningElement {

    loanList;
    isLoading = false;
    wiredResult;


    showToast(title, message, variant){

        this.dispatchEvent(
            new ShowToastEvent({
                title,
                message,
                variant
            })
        );
    }


    //Get all Pending Loans
    @wire(getPendingLoans)
    wiredPendingLoans(result){
        this.wiredResult = result;
        if(result.data){
            this.loanList = result.data;
        }else if(result.error){
            console.log(error);
        }
        
    }

    handleLoanApproval(event){
        const loanId = event.detail;
        this.isLoading = true;
        

        //Imperative Apex call
        approveLoan({recordId :loanId})
        .then(result =>{
            this.showToast('Success', result, 'success');

            return refreshApex(this.wiredResult);
        })
        .catch(error => {

            this.showToast('Error', error.body.message, 'error');
        })
        .finally(() => {

            this.isLoading = false;
        });
    }

    handleLoanRejection(event){
        const loanId = event.detail;
        this.isLoading = true;
        

        //Imperative Apex call
        rejectLoan({recordId :loanId})
        .then(result =>{
            this.showToast('Success', result, 'success');

            return refreshApex(this.wiredResult);
        })
        .catch(error => {

            this.showToast('Error', error.body.message, 'error');
        })
        .finally(() => {

            this.isLoading = false;
        });

    }

}