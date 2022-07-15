/**
 * Created by jkaluzny on 14.07.2022.
 */



public with sharing class CreateAdoptionFromOCRForm {
    public static final String FIRST_NAME = 'firstName';
    public static final String LAST_NAME = 'lastName';
    public static final String ANIMAL_ID = 'animalID';
    public static final String RECORD_TYPE_ID = 'recordTypeId';
    public static final String RECORD_TYPE = 'recordType';
    public static final String AMOUNT = 'amount';
    public static final String CONTACT_ID = 'contactID';
    public static final String ANIMAL_NAME = 'animalName';

    @AuraEnabled(Cacheable=true)
    public static List<String> createAdoptionData(String strBase64) {
        einsteinplay.Einstein_PredictionResult einstein = Einstein.getOCRFromPDF(strBase64);

        Map<String, String> OCRLabelValueMap = new Map<String, String>();

        for(einsteinplay.Einstein_Probability eins : einstein.probabilities){
            if (eins.attributes.tag.equals('PERSON')) {
                OCRLabelValueMap.put(FIRST_NAME, eins.label);
                continue;
            }

            String[] splittedLabel = eins.label.split(':');
            if (splittedLabel.size() <= 1) {
                continue;
            }
            String labelCategory = splittedLabel[0];
            String labelValue = splittedLabel[1].substring(1);

            switch on labelCategory {
                when 'Last Name' {
                    OCRLabelValueMap.put(LAST_NAME, labelValue);
                }
                when 'Animal Name' {
                    OCRLabelValueMap.put(ANIMAL_NAME, labelValue);
                    List<Animal__c> animal = [SELECT Id FROM Animal__c WHERE Name LIKE :labelValue LIMIT 1];
                    if (animal.isEmpty()) {
                        OCRLabelValueMap.put(ANIMAL_ID, 'error');
                    } else {
                        OCRLabelValueMap.put(ANIMAL_ID, animal.get(0).Id);
                    }
                }
                when 'Adoption Type' {
                    OCRLabelValueMap.put(RECORD_TYPE, labelValue);

                    String recordTypeId = 'error';
                    if (Pattern.matches('(?i)(virtual)|(real)', labelValue)) {
                        recordTypeId = Schema.SObjectType.Adoption__c.getRecordTypeInfosByDeveloperName().get(labelValue).getRecordTypeId();
                    }
                    OCRLabelValueMap.put(RECORD_TYPE_ID, recordTypeId);
                }
                when 'Amount*' {
                    if (Pattern.matches('(?i)virtual', OCRLabelValueMap.get(RECORD_TYPE))) {
                        OCRLabelValueMap.put(AMOUNT, labelValue);
                    } else {
                        OCRLabelValueMap.put(AMOUNT, 'empty');
                    }
                }
            }
        }

        String firstName = OCRLabelValueMap.get(FIRST_NAME);
        String lastName = OCRLabelValueMap.get(LAST_NAME);
        List<Contact> contact  = [SELECT Id FROM Contact WHERE FirstName LIKE :firstName AND LastName LIKE :lastName LIMIT 1];
        if (contact.isEmpty()) {
            OCRLabelValueMap.put(CONTACT_ID, 'empty');
        }
        else{
            OCRLabelValueMap.put(CONTACT_ID, contact.get(0).Id);
        }


        List<String> adoptionData = new List<String>();
        adoptionData.add(OCRLabelValueMap.get(FIRST_NAME));
        adoptionData.add(OCRLabelValueMap.get(LAST_NAME));
        adoptionData.add(OCRLabelValueMap.get(CONTACT_ID));
        adoptionData.add(OCRLabelValueMap.get(ANIMAL_NAME));
        adoptionData.add(OCRLabelValueMap.get(ANIMAL_ID));
        adoptionData.add(OCRLabelValueMap.get(RECORD_TYPE));
        adoptionData.add(OCRLabelValueMap.get(RECORD_TYPE_ID));
        adoptionData.add(OCRLabelValueMap.get(AMOUNT));

        return adoptionData;
    }
}