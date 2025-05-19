package com.pdm.projetpdm.controllers;

import com.pdm.projetpdm.request.PhraseRequest;
import com.pdm.projetpdm.services.PhraseService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.LinkedHashMap;
import java.util.Map;

@RestController
@RequestMapping("/phrase")
public class PhraseController {

    @Autowired private PhraseService phrasService;

   @PostMapping("/uploadPhrase")
   @CrossOrigin(origins = "http://localhost:4200/")
    public ResponseEntity<Map<String,Object>>uploadPhrase(@RequestBody PhraseRequest phraseRequest){

       Map<String,Object> response = new LinkedHashMap<>();
       phrasService.addPhrase(phraseRequest.category, phraseRequest.phrase);
       return ResponseEntity.ok(response);
   }

   @GetMapping("/getPhrase")
   @CrossOrigin(origins = "http://localhost:4200/")
    public ResponseEntity<Map<String, Object>> getPhrase(@RequestBody String category){
       Map<String,Object> response = new LinkedHashMap<>();
       System.out.println("Category: " + category);
       String phrase = phrasService.getPhrase(category);
       response.put("phrase", phrase);
       return ResponseEntity.ok(response);
   }


}
