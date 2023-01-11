/**
 * author: Ngum Buka Fon Nyuydze
 * organisation: Hi Corp
 * email: ngumbukafon@gmail.com
 * created-on: 11/01/2023
 * Description: Global Apex Type for lead objects with associated interview objects
 */

global class LeadWithInterview{
    public id id ;
    public string firstName;
    public string lastName;
    public string address;
    public string city;
    public string stateProvince;
    public string postalCode;
    public string primaryPhone;
    public string email;
    public Integer leadOid;
    public string leadSource;
    public list<Interview> interview; 
}