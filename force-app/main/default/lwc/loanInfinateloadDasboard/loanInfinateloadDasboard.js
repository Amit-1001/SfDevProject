import getPaginatedLoans from '@salesforce/apex/LoanApplicationHelper.getPaginatedLoans';
import { LightningElement } from 'lwc';

export default class LoanInfinateloadDasboard extends LightningElement {

    isLoading = false;
    loanList = [];

    currentPage =1;
    pageSize = 20;

    hasMoreData = true;

    columns =[
        {label:'Id', fieldName:'Id'},
        {label:'Loan Name',fieldName:'Name'},
        {label:'CustomerName',fieldName:'CustomerName'},
        {label:'Amount',fieldName:'Loan_Amount__c'},
        {label:'Status',fieldName:'Status__c'},
    ];

    connectedCallback(){
            // Initial data loading
            this.loadInitialLoans();
    }

    loadInitialLoans(){
        this.isLoading = true;

        getPaginatedLoans({pageSize: this.pageSize, pageNumber: this.currentPage})
        .then(result=>{
            

            this.loanList = result.map(loan=>{
                return{
                    ...loan,
                    CustomerName: loan.Customer__r.Name
                }
            
            });
        })
        .catch(error=>{
            console.log(error);
        })
        .finally(()=>{
            this.isLoading = false;
        })
    }


    loadMoreData(event){
    
    //duplicate Apex calls check and no data check 
    // this will remove infinite loading of data from backend
    if(this.isLoading || !this.hasMoreData){

        return;
    }

    this.isLoading = true;


    getPaginatedLoans({

        pageSize: this.pageSize,
        //here we have already fetched page 1 in initialLoanloading
        pageNumber:this.currentPage +1 
    })

    .then(result=>{

        const newRecords = result.map(loan=>{

            return{

                ...loan,

                CustomerName:
                loan.Customer__r?.Name
            };
        });

        // APPEND RECORDS
        this.loanList = [

            ...this.loanList,

            ...newRecords
        ];

        // after successfull loading we increase page size
        this.currentPage++;

        // STOPPING LOGIC no need to scroll we our result is less than pagesize. we stop infiniteloading
        if(result.length === 0 || result.length < this.pageSize){
            this.hasMoreData = false;
            event.target.enableInfiniteLoading =false;
        }
    })

    .catch(error=>{

        console.log(error);
    })

    .finally(()=>{

        this.isLoading = false;
    });
}

}