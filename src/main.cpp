#include <fstream>
#include <iostream>
#include <string>
#include <vector>
#include <thread>
#include <chrono>
#include <tinyxml2.h>

std::string simulateAction(const std::string& type, const std::string& value ){

    if(type == "send"){
        std::cout << "[SIMULAZIONE] invio comando: " << value << std::endl;
        //corpo logica della risposta del device
        //semplificato ristampa semplicemente il messagio
        return value;
    }

    else if(type == "receive"){
        std::cout << "[SIMULAZIONE] attendo messaggio" << std::endl;
        //corpo logica di ricezione
        //simulo con un messaggio fisso
        return "hello";
    }

    else if(type == "wait"){
        std::cout << "[SIMULAZIONE] attendo " << value << "s" <<std::endl;
        std::this_thread::sleep_for(std::chrono::seconds(std::stoi(value)));
        return "done";
    }

    return "";
}

struct Step{
    std::string id;
    std::string action;
    std::string actionType;
    std::string expected;
};

struct TestCase{
    std::string id;
    std::string description;
    std::vector<Step> steps;
};


int main(int argc,char* argv[]){

    tinyxml2::XMLDocument doc;

    if(!argv[1]) {
        std::cerr << "Errore, input file vuoto" << std::endl;
        return 1;
    }


    if (doc.LoadFile(argv[1]) != tinyxml2::XML_SUCCESS ){
            std::cerr << "Errore nell-apertura del file XML" << std::endl;
            return 1;
    }


    tinyxml2::XMLElement* testCaseElem = doc.FirstChildElement("TestCase");
    if(!testCaseElem){
        std::cerr << "Nessun TestCase trovato!" << std::endl;
        return 1;
    }

    TestCase tc;
    tc.id = testCaseElem->Attribute("id");
    
    tinyxml2::XMLElement* descElem = testCaseElem->FirstChildElement("Description");
    if(descElem && descElem->GetText()){
        tc.description = descElem->GetText();
    }

    for(tinyxml2::XMLElement* stepElem = testCaseElem->FirstChildElement("Step");
        stepElem != nullptr;
        stepElem = stepElem->NextSiblingElement("Step"))
        {
            Step ghostStep;

            tinyxml2::XMLElement* actionElem = stepElem->FirstChildElement("Action");
            tinyxml2::XMLElement* expectedElem = stepElem->FirstChildElement("Expected");

            ghostStep.id = stepElem->Attribute("id");

            if(actionElem){
                ghostStep.actionType = actionElem->Attribute("type");

                if(actionElem->GetText()){
                    ghostStep.action = actionElem->GetText();

                }
            }


            if(expectedElem && expectedElem->GetText()){
                ghostStep.expected = expectedElem->GetText();
            }

            std::cout << "[STEP "<< ghostStep.id << "] " 
                << "Action: " << ghostStep.actionType
                <<  "-> \"" << ghostStep.action << "\"" << std::endl;

            
            std::string result = simulateAction(ghostStep.actionType,ghostStep.action);


            if (result == ghostStep.expected) {
            std::cout << "[RISULTATO] PASS ✅ (atteso=" << ghostStep.expected 
                      << ", ottenuto=" << result << ")\n\n";
            } else {
                std::cout << "[RISULTATO] FAIL ❌ (atteso=" << ghostStep.expected 
                      << ", ottenuto=" << result << ")\n\n";
            }
    }

    return 0;

}