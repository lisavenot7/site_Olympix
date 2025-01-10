<?php
namespace App\Controllers;

use App\Models\Db_model;
use CodeIgniter\Exceptions\PageNotFoundException;

class Candidature extends BaseController
{
    public function __construct(){
        helper('form');
        $this->model = model(Db_model::class);
    }

    public function afficher($code){
        echo $this->request->getMethod();
        if($code == " "){
                return redirect()->to('/');
            }
            else{
                $data['titre'] = 'Candidature :';
                $data['t']="";
                $data['can'] = $this->model->get_candidature($code);
                $data['docs'] = $this->model->get_documents_candidature($code);

                return view('templates/haut')
                .view('menu_visiteur',$data)
                .view('candidature/affichage_candidature')
                .view('templates/bas');
            }
        
    }

    public function suivi(){
        // L’utilisateur a validé le formulaire en cliquant sur le bouton
        if ($this->request->getMethod()=="POST"){
            if (! $this->validate([
                'ci' => 'required|max_length[20]|min_length[20]',
                'cc' => 'required|max_length[8]|min_length[8]'
            ],
            [ // Configuration des messages d’erreurs
                'ci' => [
                    'required' => 'Veuillez entrer un code d\'inscription !',
                    'min_length' => 'Le code d\'inscription contient 20 caractères !',
                    'max_length' => 'Le code d\'inscription contient 20 caractères !',
                ],
                'cc' => [
                    'required' => 'Veuillez entrer un code de candidat !',
                    'min_length' => 'Le code de candidat contient 8 caractères !',
                    'max_length' => 'Le code de candidat contient 8 caractères !',
                ],
            ]
            ))
            {
            // La validation du formulaire a échoué, retour au formulaire !
            return view('templates/haut')
                . view('menu_visiteur',['titre' => 'SUIVI D\'UNE CANDIDATURE','t' => ' '])
                . view('candidature/retrouver_candidature')
                . view('templates/bas');
            }
            // La validation du formulaire a réussi, traitement du formulaire
            $code=$this->request->getVar('ci');
            $c=$this->request->getVar('cc');
            
            if ($this->model->get_can($code,$c)==true){
                $data['titre'] = 'Candidature :';
                $data['t']="";
                $data['can'] = $this->model->get_candidature($code);
                $data['docs'] =$this->model->get_documents_candidature($code);
                return view('templates/haut')
                    . view('menu_visiteur',$data)
                    . view('candidature/affichage_candidature')
                    . view('templates/bas');
            }
            else{ return view('templates/haut')
                . view('menu_visiteur',['titre' => 'SUIVI D\'UNE CANDIDATURE','t' => 'Codes éronnées ou inexistant '])
                . view('candidature/retrouver_candidature')
                . view('templates/bas');
            }
        }
        
        // L’utilisateur veut afficher le formulaire pour créer un compte
        return view('templates/haut')
                . view('menu_visiteur',['titre' => 'SUIVI D\'UNE CANDIDATURE','t' => ' '])
                . view('candidature/retrouver_candidature')
                . view('templates/bas');
    }

    public function supprimer($code,$c){
        $this->model->delete_documents($code);
        $this->model->delete_notes($code);
        $d=$this->model->delete_candidature($code);
        if($d==true){
             return view('templates/haut')
        .view('menu_visiteur')
        .view('candidature/supprimer_candidature')
        .view('templates/bas');
        }
        else{
            $data['titre'] = 'Candidature :';
                $data['t']='Votre candidature n\'a pas pu etre supprimer';
                $data['can'] = $this->model->get_candidature($code);
                $data['docs'] =$this->model->get_documents_candidature($code,$c);
                return view('templates/haut')
                    . view('menu_visiteur',$data)
                    . view('candidature/affichage_candidature')
                    . view('templates/bas');
        }
        

       
    
        
    }

    
}
?>