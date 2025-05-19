package com.pdm.projetpdm.services.interfaces;

import java.util.List;
import java.util.Map;

public interface IPhraseService {
    public void printPhrases();
    public void addPhrase(String category, String phrase);
    public void addPhrases(Map<String, List<String>> newPhrases);
    public String getPhrase(String category);
    public List<String> getPhrases(String category);
}