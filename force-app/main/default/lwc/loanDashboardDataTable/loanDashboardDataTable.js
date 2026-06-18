import { LightningElement, wire } from 'lwc';
import getPendingLoans from '@salesforce/apex/LoanApplicationHelper.getPendingLoans';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import { refreshApex } from '@salesforce/apex'; // Needed to refresh @wire
import approveLoan from '@salesforce/apex/LoanApplicationHelper.approveLoan';

export default class LoanDashboardDataTable extends LightningElement {

    loanList =[];

    isLoading = false;

    wiredResult;


    // Id, Name , Customer__r.Name , Loan_Amount__c,Status__c

    columns =[
        // FieldName should be same as Data we are getting from List(getPendingLoans)
        {label: 'Loan Id', fieldName : 'Id'},
        {label: 'Loan Name', fieldName : 'Name'},
        {label: 'CustomerName',fieldName: 'CustomerName'}, //using Flatten Field
        {label: 'Amount', fieldName: 'Loan_Amount__c', type:'number'},
        {label: 'Status', fieldName: 'Status__c'},

        {   label:'Approve', // this shows on header
            type:'button',
            typeAttributes :{
                label: 'Approve', // this shows on button
                name: 'approve',
                variant: 'brand'
            }
        },

        {   label:'Reject',
            type:'button',
            typeAttributes :{
                label:'Reject',
                name:'reject',
                variant: 'destructive'
            }
        }

    ];


    @wire(getPendingLoans)
    wirePendingLoans(result){
        this.wiredResult = result;
        if(result.data){
            // falttening related field
            // relation field is not allowed in DataTable
            this.loanList = result.data.map(loan=>{
                return {
                    ...loan,
                    CustomerName: loan.Customer__r.Name
                };
            });
        }
        else if(result.error){
            console.log(result.error);
        }
    }

    handleRowAction(event){
        const actionName = event.detail.action.name; // button name we are getting based on button we press
        const row = event.detail.row;

        if(actionName == 'approve'){
            this.handleApprove(row.Id);
                
        }else if(actionName =='reject'){
            this.handleReject(row.Id);
        }
    }

    handleApprove(recordId){
        this.isLoading = true;

        approveLoan({recordId})
        .then(result => {
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

     // 🔥 Reject logic
    handleReject(recordId){
        this.isLoading = true;

        rejectLoan({ recordId })
        .then(result => {
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

      // 🔥 Toast helper
    showToast(title, message, variant){
        this.dispatchEvent(
            new ShowToastEvent({ title, message, variant })
        );
    }







}