/*********************************
ClassName: sendOrderasInput
TextClassName: sendOrderasInputText
Description : Send Order Number and Contact email to NPS API
Date & Author: 25-09-2023, ShaliniPerneti
**********************************/

public class sendOrderasInput {
    @InvocableMethod(label='Get Order Names' description='Returns the list of Order names with respect to Contact email' category='Order' )
    public static void getorder(List<ID> orderids) { // get Order IDs from Flow bulider
        map<string, string> Ordernumber = new map <string, string>();
        List<order> orderlist = [select id,OrderNumber,AccountId,Status, BillToContact.Account.id,BillToContact.Email from order where id in: orderids and Status = 'Fulfilled']; 
        if(orderlist.size() > 0){ 
            List<String> EmailIdList = new List<String>();
            for (Order ordr : orderlist) { 
                If(!EmailIdList.contains(ordr.BillToContact.Email)){ // Avoid duplicate email
                    EmailIdList.add(ordr.BillToContact.Email);                    
                    Ordernumber.put('BilltoContactEmail', ordr.BillToContact.Email); 
                }
                Ordernumber.put('OrderNumber', orderlist[0].OrderNumber);  // Can also use 'For' loop to iterate List
                system.debug('OrderNumber');
                sendToNPSAPI(Ordernumber);
            }
        }
    }
    @future(callout=true)
    public static void sendToNPSAPI(map<string, string> dataNPS){
        String username = 'tmondo';
        string password = 'Noy84LRpYvMZuETB';
        string APIUrl = 'https://salesforce-coding-challenge.herokuapp.com';
        Http htp = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(APIUrl);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Authorization', 'Basic ' + EncodingUtil.base64Encode(Blob.valueOf(username + ':' + password)));
        req.setBody(JSON.serialize(dataNPS));
        HttpResponse res = htp.send(req);
        if(res.getStatusCode()==200){
            String Success = 'Success getting a request token. HTTP Code = '+res.getStatusCode()+'. Message: '+res.getStatus()+'. Response Body: '+res.getBody();
            system.debug(Success);
        }
        else if(res.getStatusCode()==400){
            String error = 'Getting a request token BAD_PAYLOAD. HTTP Code = '+res.getStatusCode()+'. Message: '+res.getStatus()+'. Response Body: '+res.getBody();
            system.debug(error);
        }
        else if(res.getStatusCode()==500){
            String servererror = 'Getting a request token SERVER_ERROR. HTTP Code = '+res.getStatusCode()+'. Message: '+res.getStatus()+'. Response Body: '+res.getBody();
            system.debug(servererror);
        }
        else{ 								// Received '404 - Not found'
            system.debug('failed'+res.getStatusCode());
            system.debug('failed'+res.getStatus()+res.getBody());
        }
    }
}