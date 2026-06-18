import getAllLoans from '@salesforce/apex/LoanApplicationHelper.getAllLoans';
import { LightningElement,wire } from 'lwc';

export default class LoanPaging extends LightningElement {


    loanList = [];

    visibleLoans = [];

    pageSize = 5;

    currentPage = 1;

    totalPages = 0;

    columns =[
        {label:'Id',fieldName:'Id'},
        {label:'Name',fieldName:'Name'},
        {label:'Loan Amount',fieldName:'Loan_Amount__c'},
        {label:'CustomerName',fieldName:'CustomerName'}
    ];


    @wire(getAllLoans)
    wiredLoans(result){
        if(result.data){
            // flatten the data
            this.loanList = result.data.map(loan=>{
                return{
                    ...loan,
                    CustomerName: loan.Customer__r.Name
                }
            })

            this.totalPages =
                Math.ceil(
                    this.loanList.length /
                    this.pageSize
                );

            this.updateVisibleLoans();
        }
    }

        updateVisibleLoans(){
            // finding starting point and ending point
            const start = (this.currentPage-1) * this.pageSize;
            const end = start + this.pageSize;

            this.visibleLoans = this.loanList.slice(start,end);
        }

        handleNext(){
            if(this.currentPage<this.totalPages){
                this.currentPage++;
                this.updateVisibleLoans();
            }
        }

        handlePrevious(){
            if(this.currentPage>1){
                this.currentPage--;
                this.updateVisibleLoans();
            }
        }

        get hasList(){
        return this.loanList && this.loanList.length > 0;
        }


}