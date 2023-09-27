@isTest
public class sendOrderasInputTest {
    static testmethod void testOrderName(){
        Account ac = new Account();
        ac.Name = 'TestAcnt';
        ac.Type = 'Prospect';
        insert ac;
        List<Contact> conlst = new List<Contact>();
        Contact con = new Contact();
        con.LastName = 'testLastName';
        con.AccountId = ac.Id;
        con.Email = 'abc@xyz.com';
        conlst.add(con);
        Contact con1 = new Contact();
        con1.LastName = 'testLastName';
        con1.AccountId = ac.Id;
        con1.Email = 'test@xyz.com';
        conlst.add(con1);
        insert conlst;
        
        Contract cont = new Contract();
        cont.AccountId = ac.Id;
        cont.StartDate = system.today();
        cont.Status =  'Draft';
        cont.ContractTerm = 3;
        insert cont;
        List<Id> OrderLstID = new List<Id>();
        List<Order> OrderLst = new List<Order>();
        Order odr = new Order();
        odr.AccountId = ac.Id;
        odr.EffectiveDate =system.today();
        odr.BillToContactId = conlst[0].Id;
        odr.ContractId = cont.Id;
        odr.Status = 'Draft';
        OrderLst.add(odr);
        Order odr1 = new Order();
        odr1.AccountId = ac.Id;
        odr1.EffectiveDate =system.today();
        odr1.BillToContactId = conlst[1].Id;
        odr1.ContractId = cont.Id;
        odr1.Status = 'Draft';
        OrderLst.add(odr1);
        Insert OrderLst;
        
        OrderLst[0].Status = 'Fulfilled';
        OrderLst[1].Status = 'Fulfilled';
        Update OrderLst;
        OrderLstID.add(OrderLst[0].ID);
        OrderLstID.add(OrderLst[1].ID);
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        sendOrderasInput.getorder(OrderLstID);
        Test.stopTest();
    }
}