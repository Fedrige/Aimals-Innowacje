public class CreateContactFromIDCard {
    
    public static final Integer NOT_IMPORTANT = 0;
    public static final Integer NAME = 1;
    public static final Integer SURNAME = 2;
    public static final Integer BIRTH_DATE = 3;

    private static List<String> getPersonalDataFromMap(Map<Integer,String> dataMap, List<Integer> sortedBoundingBoxYPos) {
        Integer dataFlag = 0;
        String namePattern = '(?i).*?[ijl]?[mn][ijl][o0gq][mn][oa]?.*';
        String surnamePattern = '(?i).*?[nm][o0a][zs]?w?is[kh][oa].*';
        String birthDatePattern = '.*?([\\dOIliZASCbdPoQ]{2}[\\.\\-\\,\\:\\;\\/][\\dOIliZASCbdPoQ]{2}[\\.\\,\\-\\:\\;\\/][\\dOIliZASCbdPoQ]{4}).*';
        List<String> personalData = new List<String>();
        
        for (Integer boundingBoxYPos: sortedBoundingBoxYPos) {
            String data = dataMap.get(boundingBoxYPos);
            system.debug(data);
            if (dataFlag != NOT_IMPORTANT) {
                personalData.add(data.substring(0,1) + data.substring(1).toLowerCase());
                dataFlag = NOT_IMPORTANT;
            }

            if (Pattern.matches(namePattern, data)) {
                //if(personalData.size() == 0){
                    dataFlag = NAME;
                //}
            } else if (Pattern.matches(surnamePattern, data)) {
                //if(personalData.size() == 1){
                    dataFlag = SURNAME;
                //}
            } else if(Pattern.matches(birthDatePattern, data)){
                data = data.replaceAll(birthDatePattern, '$1');
                System.debug('DATAAAA::: ' + data);
 				data = data
                        .replaceAll('[\\.\\-\\,\\:\\;\\/]', '-')
                        .replaceAll('O', '0')
                        .replaceAll('[Ili]', '1')
                        .replaceAll('Z', '2')
                        .replaceAll('A', '4')
                        .replaceAll('S', '5')
                        .replaceAll('[Cb]', '6')
                        .replaceAll('[dPoq]', '8');
                
                String[] dataParts = data.split('-');

                System.debug(dataParts);

                String parsedData = dataParts[2] + '-' + dataParts[1] + '-' + dataParts[0];
                Date birthDate = Date.valueOf(parsedData);

                System.debug('data: ' + birthDate);
                System.debug('data today: ' + Date.today());

                if (birthDate < Date.today()) {
                    personalData.add(parsedData.replaceAll('-', '/'));
                    System.debug('po if: ' + data);
                }

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
        
        
        //system.debug(labelsMap);
        return getPersonalDataFromMap(labelsMap, sortedBoundingBoxYPos);
    }
}