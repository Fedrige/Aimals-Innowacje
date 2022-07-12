public class CreateContactFromIDCard {
    
    public static final Integer NOT_IMPORTANT = 0;
    public static final Integer NAME = 1;
    public static final Integer SURNAME = 2;
    
    private static List<String> getPersonalDataFromMap(Map<Integer,String> dataMap, List<Integer> sortedBoundingBoxYPos) {
        Integer dataFlag = 0;
        String namePattern = '(?i).*?[ijl]?[mn][ijl][o0gq][mn][oa]?.*';
        String surnamePattern = '(?i).*?[nm][o0a][zs]?w?is[kh][oa].*';
        List<String> personalData = new List<String>();
        
        for (Integer boundingBoxYPos: sortedBoundingBoxYPos) {
            String data = dataMap.get(boundingBoxYPos);
            if (dataFlag != NOT_IMPORTANT) {
                personalData.add(data.substring(0,1) + data.substring(1).toLowerCase());
                dataFlag = NOT_IMPORTANT;
            }
            
            if (Pattern.matches(namePattern, data)) {
                dataFlag = NAME;
            } else if (Pattern.matches(surnamePattern, data)) {
                dataFlag = SURNAME;
            }
        }
        
        return personalData;
    }

	@AuraEnabled(cacheable=true)
    public static List<String> getOCRFromImage(String strBase64){
        String sampleId='';
        einsteinplay.Einstein_PredictionService einsteinService = new einsteinplay.Einstein_PredictionService(
                einsteinplay.Einstein_PredictionService.Types.IMAGE
            );
        einsteinplay.Einstein_PredictionResult einstein = new einsteinplay.Einstein_PredictionResult();
        einstein=einsteinService.predictOcrBase64('OCRModel',strBase64,'contact',sampleId);
    
        String probability=einstein.probabilities.get(0).label;

        Map<Integer,String> labelsMap = new Map<Integer,String>();
        List<Integer> sortedBoundingBoxYPos = new List<Integer>();
        
        for(einsteinplay.Einstein_Probability eins : einstein.probabilities){
            labelsMap.put(eins.boundingBox.minY, eins.label);
            sortedBoundingBoxYPos.add(eins.boundingBox.minY);
        }
        sortedBoundingBoxYPos.sort();
        System.debug('test2');
        
        
        //system.debug(labelsMap);
        return getPersonalDataFromMap(labelsMap, sortedBoundingBoxYPos);
    }
}