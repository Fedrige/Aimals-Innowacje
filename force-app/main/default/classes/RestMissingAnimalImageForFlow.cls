public class RestMissingAnimalImageForFlow {
	@InvocableMethod(label='missing animal image')
    public static List<String> getMissingAnimalImageForFlow(List<Id> missingAnimalId){
        String temp = RestMissingAnimal.getMissingAnimalImageRestFlow(missingAnimalId.get(0));
      	List<String> listOfOneAnimalImage = new List<String>();
        listOfOneAnimalImage.add(temp);
        return listOfOneAnimalImage;
    }
    
    
}