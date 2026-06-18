import { LightningElement, track, wire } from 'lwc';
import searchBooking from '@salesforce/apex/BookingLWCHelper.searchBooking';

export default class Wirebookingsearch extends LightningElement {


    @track bookingName = '';

    bookings

    handleChange(event){
        this.bookingName = event.target.value;
    }


    @wire (searchBooking, {bookingName:'$bookingName'})
    wirebookingsearch({ error, data }){
        if(data){
            this.bookings = data;
        }else if(error){
            console.error(error);
        }
    }



}