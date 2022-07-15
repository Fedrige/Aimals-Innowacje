public class Einstein {
    @AuraEnabled(cacheable=true)
    public static String getBreedOfAnimal(String strBase64){
        System.debug('einstein');
        String modelId='W37CRWEAGCDS3XPN2X72ASAHJ4';
        String sampleId='';
        einsteinplay.Einstein_PredictionService einsteinService = new einsteinplay.Einstein_PredictionService(
                einsteinplay.Einstein_PredictionService.Types.IMAGE
            );
        einsteinplay.Einstein_PredictionResult einstein = new einsteinplay.Einstein_PredictionResult();
        einstein=einsteinService.predictImageBase64(modelId,strBase64,1,sampleId);
    
        String probability=einstein.probabilities.get(0).label;
        System.debug(einstein);
        return probability;
    }

    @AuraEnabled(cacheable=true)
    public static einsteinplay.Einstein_PredictionResult getOCRFromPDF(String strBase64) {
        String sampleId = '';
        einsteinplay.Einstein_PredictionService einsteinService = new einsteinplay.Einstein_PredictionService(
                einsteinplay.Einstein_PredictionService.Types.IMAGE
        );
        einsteinplay.Einstein_PredictionResult einstein = new einsteinplay.Einstein_PredictionResult();
        einstein = einsteinService.predictOcrBase64('OCRModel', strBase64, 'contact', sampleId);

        return einstein;
    }
}