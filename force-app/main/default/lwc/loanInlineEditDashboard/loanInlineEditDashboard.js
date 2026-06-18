import getPendingLoans from '@salesforce/apex/LoanApplicationHelper.getPendingLoans';
import updateLoan from '@salesforce/apex/LoanApplicationHelper.updateLoan';
import { LightningElement, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import { refreshApex } from '@salesforce/apex'; // Needed to refresh @wire
export default class LoanInlineEditDashboard extends LightningElement {

    loanList;

    wiredResult;

    isLoading = false;

    draftValues =[];
    /* 
        Id
        Name
        Loan_Amount__c
        Status__c
    */
    columns =[
        {label:'Name',fieldName :'Name'},
        {
        label: 'Amount',
        fieldName: 'Loan_Amount__c',
        type: 'number',
        editable: true
        },

        {
            label: 'Status',
            fieldName: 'Status__c',
            editable: true
        }
    ];

    @wire(getPendingLoans)
    wiredLoans(result){
        this.wiredResult = result;
        if(result.data){
            this.loanList =result.data;
        }else if(result.error){
            console.log(result.error);
        }
    }

    handleSave(event){
        this.draftValues = event.detail.draftValues;
        this.isLoading = true;
        updateLoan({loanList:this.draftValues})
        .then(result=>{
            this.showToast('Success',result,'success');
            refreshApex(this.wiredResult);
            this.draftValues = [];
            
        })
        .catch(error=>{
            this.showToast('Error',error.body.message,'error');
        })
        .finally(()=>{
            this.isLoading = false;
        })
        
    }


    showToast(title,message,variant){
        this.dispatchEvent(
            new ShowToastEvent({
                title,
                message,
                variant
            })
        );
    }



}