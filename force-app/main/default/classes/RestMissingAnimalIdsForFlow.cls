public class RestMissingAnimalIdsForFlow {
    
    @InvocableMethod(label='missing animals ids')
    public static List<List<Id>> getMissingAnimalsForFlow(){
        List<Id> restList = RestMissingAnimal.getMissingAnimals(1);
        List<List<Id>> listOfListOfIds = new List<List<Id>>();
        listOfListOfIds.add(restList);
        return listOfListOfIds;
    }
}