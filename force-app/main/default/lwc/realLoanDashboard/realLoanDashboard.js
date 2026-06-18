import { LightningElement, track,wire } from 'lwc';

import {refreshApex} from '@salesforce/apex'
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import searchLoanByName from '@salesforce/apex/LoanApplicationHelper.searchLoanByName';
import updateLoan from '@salesforce/apex/LoanApplicationHelper.updateLoan';
import approveLoan from '@salesforce/apex/LoanApplicationHelper.approveLoan';
import rejectLoan from '@salesforce/apex/LoanApplicationHelper.rejectLoan';


export default class RealLoanDashboard extends LightningElement {
    /**
     * 
            ✔ Search loans
            ✔ Sort by amount
            ✔ Edit status inline
            ✔ Approve/Reject
            ✔ Navigate pages
            ✔ See only current page data
     */

    @track name = '';

    loanList =[];
    wiredResult;
    isLoading = false;
    draftValues =[];
    sortBy;
    sortDirection;

    visibleLoans = [];

    pageSize = 5;

    currentPage = 1;

    totalPages = 0;

    delayInterval;

    serachTerm;

    columns=[

        {label:'Id', fieldName:'Id'},
        {label:'Loan Name',fieldName:'Name'},
        {label:'CustomerName',fieldName:'CustomerName'},
        {label:'Amount',fieldName:'Loan_Amount__c', sortable:true, type:'number'},
        {label:'Status',fieldName:'Status__c', editable:true},

        {
            label:'Approve',
            type:'button',
            typeAttributes:{
                label: 'Approve', // this shows on button
                name: 'approve', //action 
                variant: 'brand'
            }
        },
        {
            label:'Reject',
            type:'button',
            typeAttributes:{
                label:'Reject',
                name:'reject',
                variant:'destructive'
            }

        }
    ];


    // debouncing logic
    handleChange(event){
        // fetching values from Input
        this.serachTerm = event.target.value;

        window.clearInterval(this.delayInterval);

        // update name only after when user stop typing for 300 ms
        this.delayInterval = setInterval(() => {
            this.name = this.serachTerm;
        }, 300);
    }


    // Serach loan By Name
    @wire(searchLoanByName,{name:'$name'})
    wiredLoans(result){
        this.wiredResult = result;

        if(result.data){
            this.loanList = result.data.map(loan=>{
                return{
                    ...loan,
                    CustomerName: loan.Customer__r.Name
                }
            })

            // reset pagination after search
            this.currentPage = 1;

            this.totalPages = Math.ceil(this.loanList.length/this.pageSize);


    
            this.updateVisibleLoan()
            
            

        }else if(result.error){
            console.log(result.error);
        }

    }

    //inline edit
    handleSave(event){
        this.draftValues = event.detail.draftValues;
        this.isLoading = true;
        updateLoan({loanList:this.draftValues})
        .then(result=>{
            this.showToast('Success',result,'success');
            this.draftValues =[];
            return refreshApex(this.wiredResult);
        })
        .catch(error=>{
            this.showToast('Error',error.body.message,'error');
        }).finally(()=>{
            this.isLoading = false;
        })
    }

    //sort
    handleSort(event){
        this.sortBy = event.detail.fieldName;
        this.sortDirection = event.detail.sortDirection;

        let temp =[...this.loanList];

        if(this.sortDirection == 'asc'){
            temp.sort((a,b)=>{
                return a.Loan_Amount__c - b.Loan_Amount__c;
            })
        }else {
            temp.sort((a,b)=>{
                return b.Loan_Amount__c - a.Loan_Amount__c;
            })
        }

        this.loanList = temp;
        this.updateVisibleLoan();
    }

    // handle Approve and Reject
    handleRowAction(event){
        const actionName = event.detail.action.name;
        const rowId  = event.detail.row.Id;

        if(actionName == 'approve'){
            this.handleApprove(rowId);

        }else if( actionName == 'reject'){
            this.handleReject(rowId);
        }
    }

    handleApprove(recordId){
        this.isLoading = true;
        approveLoan({recordId: recordId})
        .then(result=>{
            this.showToast('Success',result,'success');
            return refreshApex(this.wiredResult);
        }).catch(error=>{
            this.showToast('Error',error.body.message,'error');
        })
        .finally(()=>{
        this.isLoading = false;
        })
    }


    handleReject(recordId){
        this.isLoading = true;
        rejectLoan({recordId: recordId})
        .then(result=>{
            this.showToast('Success',result,'success');
            return refreshApex(this.wiredResult);
        }).catch(error=>{
            this.showToast('Error',error.body.message,'error');
        })
        .finally(()=>{
        this.isLoading = false;
        })
    }


    //Pagination

    updateVisibleLoan(){
        const start = (this.currentPage-1) * this.pageSize;
        const end = start + this.pageSize;
        // Slice current list 
        this.visibleLoans = this.loanList.slice(start,end);
    }

    handleNext(){
        if(this.currentPage<this.totalPages){
            this.currentPage++;
            this.updateVisibleLoan();
        }
    }

    handlePrevious(){
        if(this.currentPage>1){
            this.currentPage--;
            this.updateVisibleLoan();
        }
    }


    showToast(title,message,variant){
        this.dispatchEvent(
            new ShowToastEvent(
                            {
                title,
                message,
                variant
            })
        );
    }

        get hasList(){
            return this.visibleLoans &&
            this.visibleLoans.length > 0;
        }


}