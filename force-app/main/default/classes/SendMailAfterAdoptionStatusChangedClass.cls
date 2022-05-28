public class SendMailAfterAdoptionStatusChangedClass {
     public static void sendMailWithSetOfAdoptionsId(Set<Id> adoptionsId){
        if(!adoptionsId.isEmpty()){
            List<Adoption__c> adoptions = [SELECT Id, Status__c, Contact__r.Email, Contact__r.FirstName, Contact__r.LastName, Contact__r.Id, Animal__r.Name, Animal__r.Id FROM Adoption__c WHERE Id IN :adoptionsId];

            for (Adoption__c adoption : adoptions){
                Contact contact = adoption.Contact__r;
                Animal__c animal = adoption.Animal__r;
                EmailManager.sendMail(contact.Email, 'Status of your adoption has changed',
                        '<html><body>Good Morning ' + contact.FirstName + ' ' + contact.LastName + '<br>Status of your adoption for your animal ' + animal.Name + ' has changed to ' + adoption.Status__c + '<br>Link to your animal: ' + URL.getSalesforceBaseUrl().toExternalForm() + '/' + animal.Id + '.</body></html>');
            }
        }
    }
}