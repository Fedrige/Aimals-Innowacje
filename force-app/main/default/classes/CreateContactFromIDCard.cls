public class CreateContactFromIDCard {
    
    public static final Integer NOT_IMPORTANT = 0;
    public static final Integer NAME = 1;
    public static final Integer SURNAME = 2;

    private static List<String> getPersonalDataFromMap(Map<Integer,String> dataMap, List<Integer> sortedBoundingBoxYPos) {
        Integer dataFlag = 0;
        String namePattern = '(?i).*?[ijl]?[mn][ijl][o0gq][mn][oa]?.*';
        String surnamePattern = '(?i).*?[nm][o0a][zs]?w?is[kh][oa].*';
        String birthDatePattern = '.*?([\\dOIliZASCbdPoQ]{2}[\\.\\-\\,\\:\\;\\/][\\dOIliZASCbdPoQ]{2}[\\.\\,\\-\\:\\;\\/][\\dOIliZASCbdPoQ]{4}).*';
        String documentNumberPattern = '\\w{3}\\s?\\d{6}';
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
            } else if(Pattern.matches(birthDatePattern, data)){
                data = data.replaceAll(birthDatePattern, '$1');
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
                String parsedData = dataParts[2] + '-' + dataParts[1] + '-' + dataParts[0];
                Date birthDate = Date.valueOf(parsedData);
                if (birthDate < Date.today()) {
                    personalData.add(parsedData);
                }
            } else if (Pattern.matches(documentNumberPattern, data)) {
                data = data.replaceAll(' ', '');
                personalData.add(data);
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

        return getPersonalDataFromMap(labelsMap, sortedBoundingBoxYPos);
    }
}