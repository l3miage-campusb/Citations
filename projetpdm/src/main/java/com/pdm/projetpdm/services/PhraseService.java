package com.pdm.projetpdm.services;

import com.pdm.projetpdm.services.interfaces.IPhraseService;
import org.springframework.stereotype.Service;
import java.util.*;

@Service
public class PhraseService implements IPhraseService {

    private Map<String, List<String>> phrases = new HashMap<>();


    @Override
    public void printPhrases() {
            for (Map.Entry<String, List<String>> entry : phrases.entrySet()) {
                String category = entry.getKey();
                List<String> phraseList = entry.getValue();
                System.out.println("Categoría: " + category);
                for (String phrase : phraseList) {
                    System.out.println(" - " + phrase);
                }
            }
        System.out.println("fin------------------------");
    }

    @Override
    public void addPhrase(String category, String phrase) {
        phrases.computeIfAbsent(category, k -> new ArrayList<>()).add(phrase);
        printPhrases();
    }

    @Override
    public void addPhrases(Map<String, List<String>> newPhrases) {
        newPhrases.forEach((tag, phraseList) ->
                phrases.computeIfAbsent(tag, k -> new ArrayList<>()).addAll(phraseList)
        );
    }

    @Override
    public String getPhrase(String category) {
        List<String> categoryPhrases = phrases.get(category);
        if (categoryPhrases == null || categoryPhrases.isEmpty()) {
            return "";
        }
        Random random = new Random();
        int randomIndex = random.nextInt(categoryPhrases.size());
        return categoryPhrases.get(randomIndex);
    }

    @Override
    public List<String> getPhrases(String category) {
        return phrases.getOrDefault(category, Collections.emptyList());
    }
}
