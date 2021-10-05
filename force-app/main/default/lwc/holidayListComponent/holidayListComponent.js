import { LightningElement, track } from 'lwc';
import getInitialData from '@salesforce/apex/HolidayController.getInitialData';
import saveSelectedHolidays from '@salesforce/apex/HolidayController.saveSelectedHolidays';

export default class HolidayListComponent extends LightningElement {
    @track
    holidayList = [];
    error;
    selectedHolidays = [];
    columns = [
        { label: 'Date', fieldName: 'date', type: 'date' },
        { label: 'Name', fieldName: 'name', type: 'text' },
        { label: 'Description', fieldName: 'description', type: 'text' }
    ];

    constructor() {
        super();
        this.getHoidays();
    }

    getHoidays() {
        getInitialData()
            .then(({ selectedHolidays, holidaysData }) => {
                if(holidaysData.meta && holidaysData.meta.code == 200) {
                    this.holidayList = holidaysData.response.holidays.map( day => ({ name: day.name, date: day.dateObj.iso, id: day.dateObj.iso, description: day.description }));
                    this.selectedHolidays = selectedHolidays || [];
                    this.error = undefined;
                } else {
                    throw new Exception();
                }
            })
            .catch((error) => {
                this.error = error;
                this.holidayList = [];
            });
    }

    handleOnSaveClick(event) {
        saveSelectedHolidays({ selectedHolidays: this.template.querySelector('lightning-datatable').getSelectedRows().map(day => day.id)})
        .then(() => {
            console.log('SUCCESS');
        })
        .catch((error) => {
            this.error = error;
            this.holidayList = [];
        });
    }
}