<?php

namespace App\Controllers;
use App\Models\Db_model;
use CodeIgniter\Exceptions\PageNotFoundException;

class Compte extends BaseController{
    public function __construct(){
        helper('form');
        $this->model = model(Db_model::class);
    }

    public function lister(){
        $data['titre']="Liste de tous les comptes: ";
        $data['logins'] = $this->model->get_all_compte();
        $session=session();
        if ($session->has('user')){
            $data['compte'] = $this->model->get_roleprofil($session->get('user'));
            if($data['compte']->r=='A'){
                    return view('templates/haut2')
                        . view('menu_administrateur', $data)
                        . view('connexion/affichage_comptes',['t'=>' '])
                        . view('templates/bas2');
                
            }
            else{
                return view('templates/haut2')
                . view('menu_jury')
                . view('connexion/compte_accueil')
                . view('templates/bas2');
            }
        }
        else{          
            return view('templates/haut', ['titre' => 'Se connecter','t' => ' '],)
                . view('connexion/compte_connecter')
                . view('templates/bas');
        } 
    }

    public function ajouter_comptes(){
        $session=session();
        if ($session->has('user')){
            $data['compte'] = $this->model->get_roleprofil($session->get('user'));
            if($data['compte']->r=='A'){
                if ($this->request->getMethod()=="POST"){
                    if (! $this->validate([
                        'role' => 'required',
                        'prenom' => 'required',
                        'nom' => 'required',
                        'pseudo' => 'required|max_length[255]|min_length[2]|valid_email|is_unique[T_COMPTE_COM.COM_identifiant]"',
                        'mdp' => 'required|max_length[255]|min_length[8]',
                        'mdp2' => 'required|matches[mdp]',
                    ],
                    [ // Configuration des messages d’erreurs
                        'role' => [
                            'required' => 'Veuillez choisir un role pour le compte !',
                        ],
                        'prenom' => [
                            'required' => 'Veuillez choisir un role pour le compte !',
                        ],
                        'prenom' => [
                            'required' => 'Veuillez entrer un prenom pour le compte !',
                        ],
                        'nom' => [
                            'required' => 'Veuillez entrer un nom pour le compte !',
                        ],
                        'pseudo' => [
                            'required' => 'Veuillez entrer un pseudo pour le compte !',
        
                            'valid_email' => 'Le Pseudo doit etre une adresse mail valide',
                            'is_unique' => 'Ce pseudo est dèjà existant'
                        ],
                        'mdp' => [
                            'required' => 'Veuillez entrer un mot de passe !',
                            'min_length' => 'Le mot de passe saisi est trop court !',
                        ],
                        'mdp2' => [
                            'required' => 'Veuillez confirmer votre mot de passe !',
                            'matches' => 'Les mots de passes saisis ne sont pas identique !',
                        ],
                        
                    ]
                    ))
                    {// La validation du formulaire a échoué, retour au formulaire !
                        return view('templates/haut2')
                            . view('menu_administrateur')
                            . view('connexion/ajouter_compte')
                            . view('templates/bas2');
                    }
                    // La validation du formulaire a réussi, traitement du formulaire
                    $recuperation = $this->validator->getValidated();
                    $role=$recuperation['role'];
                    if($role=='A'){
                        $this->model->set_compte_1($recuperation);
                        $id=$this->model->get_id_compte($recuperation['pseudo']);
                        $this->model->set_compte_admin2($id->COM_idCompte);
                    }
                    else{
                        $this->model->set_compte_1($recuperation);
                        $id=$this->model->get_id_compte($recuperation['pseudo']);
                        $this->model->set_compte_jury2($_POST['de'],$_POST['url'],$_POST['bio'],$id->COM_idCompte);
                    }
                    $data['titre']="Liste de tous les comptes: ";
                    $data['logins'] = $this->model->get_all_compte();
                    return view('templates/haut2')
                        . view('menu_administrateur', $data)
                        . view('connexion/affichage_comptes',['t'=>'Compte  crée avec succès'])
                        . view('templates/bas2');
                }    
                return view('templates/haut2')
                . view('menu_administrateur')
                . view('connexion/ajouter_compte')
                . view('templates/bas2');
            }
            else{
                return view('templates/haut2')
                . view('menu_jury')
                . view('connexion/compte_accueil')
                . view('templates/bas2');
            }
        }
        else{          
            return view('templates/haut', ['titre' => 'Se connecter','t' => ' '],)
                . view('connexion/compte_connecter')
                . view('templates/bas');
        } 
    }





    public function creer(){
        // L’utilisateur a validé le formulaire en cliquant sur le bouton
        if ($this->request->getMethod()=="POST"){
            if (! $this->validate([
                'prenom' => 'required',
                'nom' => 'required',
                'pseudo' => 'required|max_length[255]|min_length[2]|valid_email',
                'mdp' => 'required|max_length[255]|min_length[8]',
                'mdp2' => 'required|matches[mdp]',
            ],
            [ // Configuration des messages d’erreurs
                'prenom' => [
                    'required' => 'Veuillez entrer un prenom pour le compte !',
                ],
                'nom' => [
                    'required' => 'Veuillez entrer un nom pour le compte !',
                ],
                'pseudo' => [
                    'required' => 'Veuillez entrer un pseudo pour le compte !',

                    'valid_email' => 'Le Pseudo doit etre une adresse mail valide',
                ],
                'mdp' => [
                    'required' => 'Veuillez entrer un mot de passe !',
                    'min_length' => 'Le mot de passe saisi est trop court !',
                ],
                'mdp2' => [
                    'required' => 'Veuillez confirmer votre mot de passe !',
                    'matches' => 'Les mots de passes saisis ne sont pas identique !',
                ],
            ]
            ))
            {
            // La validation du formulaire a échoué, retour au formulaire !
            return view('templates/haut')
                . view('menu_visiteur',['titre' => 'CRÉATION D\'UN COMPTE'])
                . view('compte/compte_creer')
                . view('templates/bas');
            }
            // La validation du formulaire a réussi, traitement du formulaire
            $recuperation = $this->validator->getValidated();
            $this->model->set_compte($recuperation);
            

            $data['le_compte']=$recuperation['pseudo'];
            $data['le_message']="Nouveau nombre de comptes : ";
            //Appel de la fonction créée dans le précédent tutoriel :
            $data['le_total']=$this->model->get_nb_comptes();
            
            return view('templates/haut')
                . view('menu_visiteur', $data)
                . view('compte/compte_succes')
                . view('templates/bas');
        }
        
        // L’utilisateur veut afficher le formulaire pour créer un compte
        return view('templates/haut')
                . view('menu_visiteur',['titre' => 'CRÉATION D\'UN COMPTE'])
                . view('compte/compte_creer')
                . view('templates/bas');
    }

    public function connecter(){
        $model = model(Db_model::class);

        // L’utilisateur a validé le formulaire en cliquant sur le bouton
        if ($this->request->getMethod()=="POST"){
            if (! $this->validate([
                'pseudo' => 'required',
                'mdp' => 'required'
            ],
            [ // Configuration des messages d’erreurs
                'pseudo' => [
                    'required' => 'Veuillez entrer un pseudo !',
                ],
                'mdp' => [
                    'required' => 'Veuillez entrer un mot de passe !',
                ],
            ]
            ))
            { // La validation du formulaire a échoué, retour au formulaire !
                return view('templates/haut')
                    . view('menu_visiteur', ['titre' => 'Se connecter','t' => ' '],)
                    . view('connexion/compte_connecter')
                    . view('templates/bas');
            }
            // La validation du formulaire a réussi, traitement du formulaire
            $username=$this->request->getVar('pseudo');
            $password=$this->request->getVar('mdp');

            if ($model->connect_compte($username,$password)==true){
                $data['compte'] = $model->get_roleprofil($username);
                $session=session();
                $session->set('user',$username);
                if($data['compte']->r=='A'){
                    return view('templates/haut2')
                    . view('menu_administrateur',$data)
                    . view('connexion/compte_accueil')
                    . view('templates/bas2');
                }
                else{
                    return view('templates/haut2')
                    . view('menu_jury',$data)
                    . view('connexion/compte_accueil')
                    . view('templates/bas2');
                }

                
            }
            else{ return view('templates/haut')
                . view('menu_visiteur', ['titre' => 'Se connecter','t' => 'Identifiant ou mot de passe incorrect'],)
                . view('connexion/compte_connecter')
                . view('templates/bas');
            }
        }    // L’utilisateur veut afficher le formulaire pour se connecter
            return view('templates/haut')
                . view('menu_visiteur', ['titre' => 'Se connecter','t' => ' '],)
                . view('connexion/compte_connecter')
                . view('templates/bas');
    }

    public function afficher_profil(){
        $session=session();     
        $model = model(Db_model::class);  
        if ($session->has('user')){
           $data['le_message']="Affichage des données du profil !";
           $data['pro'] = $this->model->get_profil($session->get('user'));
           $data['compte'] = $model->get_roleprofil($session->get('user'));
           $data['t']="";
           
           if($data['compte']->r=='A'){
            return view('templates/haut2')
            . view('menu_administrateur',$data)
            . view('connexion/compte_profil')
            . view('templates/bas2');
            }
            else{
                return view('templates/haut2')
                . view('menu_jury',$data)
                . view('connexion/compte_profil')
                . view('templates/bas2');
            }}
        else{          
            return view('templates/haut')
            . view('menu_visiteur', ['titre' => 'Se connecter','t' => ' '],)
                . view('connexion/compte_connecter')
                . view('templates/bas');
        }    
    }    
    
    public function deconnecter(){
        $session=session();
        $session->destroy();
        return view('templates/haut')
            . view('menu_visiteur', ['titre' => 'Se connecter','t' => ' '],)
            . view('connexion/compte_connecter')
            . view('templates/bas');    
    }

    public function concours_jury(){
        $session=session();     
        $model = model(Db_model::class);  
        if ($session->has('user')){
           $data['le_message']="Affichage des concours !";
           $data['concours'] = $this->model->get_concours_jury($session->get('user'));
           $data['compte'] = $model->get_roleprofil($session->get('user'));
           
           
           if($data['compte']->r=='J'){
            return view('templates/haut2')
                . view('menu_jury',$data)
                . view('connexion/compte_concoursjury')
                . view('templates/bas2');
           
            }
            else{
                 return view('templates/haut2')
            . view('menu_administrateur',$data)
            . view('connexion/compte_accueil')
            . view('templates/bas2');
                
            }
        }
        else{          
            return view('templates/haut', ['titre' => 'Se connecter','t' => ' '],)
                . view('connexion/compte_connecter')
                . view('templates/bas');
        }    
    }  

    public function concours_admin(){
        $session=session();     
        $model = model(Db_model::class);  
        if ($session->has('user')){
           $data['le_message']="Affichage des concours !";
           $data['concours'] = $this->model->get_all_concours();
           $data['compte'] = $model->get_roleprofil($session->get('user'));
           

           
           if($data['compte']->r=='A'){
            return view('templates/haut2')
            . view('menu_administrateur',$data)
            . view('connexion/compte_concoursadmin')
            . view('templates/bas2');
            }
            else{
                return view('templates/haut2')
                . view('menu_jury',$data)
                . view('connexion/compte_accueil')
                . view('templates/bas2');
               
           }
        }
        else{          
            return view('templates/haut', ['titre' => 'Se connecter','t' => ' '],)
                . view('connexion/compte_connecter')
                . view('templates/bas');
        }    
    }

    public function c_preselec($id){
        $session=session();
        $model = model(Db_model::class);
        if ($session->has('user')){
            $data['compte'] = $model->get_roleprofil($session->get('user'));
            if($id == " "){
                return redirect()->to('/');
            }
            elseif($data['compte']->r=='A'){
                $data['can'] = $model->get_can_preselec($id);
                $data['cat'] = $model->get_categorie($id);
                $data['docs'] = $model->get_can_doc_preselec($id);
                

                return view('templates/haut2')
                .view('menu_administrateur',$data)
                .view('connexion/candidature_preselec')
                .view('templates/bas2');
            }
            else{
                return view('templates/haut2')
                . view('menu_jury',$data)
                . view('connexion/compte_accueil')
                . view('templates/bas2');
               
           }
       }
        else{
            return view('templates/haut', ['titre' => 'Se connecter','t' => ' '],)
                . view('connexion/compte_connecter')
                . view('templates/bas');
        }
    }

    public function c_preselection($id){
        $session=session();
        $model = model(Db_model::class);
        if ($session->has('user')){
            $data['compte'] = $model->get_roleprofil($session->get('user'));
            if($id == " "){
                return redirect()->to('/');
            }
            elseif($data['compte']->r=='J'){
                $data['can'] = $model->get_can_preselec($id);
                $data['cat'] = $model->get_categorie($id);
                $data['docs'] = $model->get_can_doc_preselec($id);
                

                return view('templates/haut2')
                .view('menu_jury',$data)
                .view('connexion/candidature_preselec')
                .view('templates/bas2');
            }
            else{
                return view('templates/haut2')
                . view('menu_administrateur',$data)
                . view('connexion/compte_accueil')
                . view('templates/bas2');
               
           }
        }
        else{
            return view('templates/haut', ['titre' => 'Se connecter','t' => ' '],)
                . view('connexion/compte_connecter')
                . view('templates/bas');
        }
    }

    public function modifier(){
        $session=session();
        if ($session->has('user')){
            $data['compte'] = $this->model->get_roleprofil($session->get('user'));
            if($data['compte']->r=='A'){
                if ($this->request->getMethod()=="POST"){
                    if (! $this->validate([
                        'prenom' => 'required',
                        'nom' => 'required',
                        'mdp' => 'required|max_length[255]|min_length[8]',
                        'mdp2' => 'required|matches[mdp]'
                    ],
                    [ // Configuration des messages d’erreurs
                        'prenom' => [
                            'required' => 'Veuillez entrer un prenom pour le compte !',
                        ],
                        'nom' => [
                            'required' => 'Veuillez entrer un nom pour le compte !',
                        ],
                        'mdp' => [
                            'required' => 'Veuillez entrer un mot de passe !',
                            'min_length' => 'Le mot de passe saisi est trop court !',
                        ],
                        'mdp2' => [
                            'required' => 'Veuillez confirmer votre mot de passe !',
                            'matches' => 'Les mots de passes saisis ne sont pas identique !',
                        ],
                    ]
                    ))
                    {// La validation du formulaire a échoué, retour au formulaire !
                        $data['titre']="Modification de votre compte !";
                        $data['pro'] = $this->model->get_profil($session->get('user'));
                        return view('templates/haut2')
                        . view('menu_administrateur',$data)
                        . view('connexion/modifier_admin')
                        . view('templates/bas2');
                    }
                    // La validation du formulaire a réussi, traitement du formulaire
                    $recuperation = $this->validator->getValidated();
                    $this->model->set_profiladmin($recuperation,$session->get('user'));
                    $data['pro'] = $this->model->get_profil($session->get('user'));
                    $data['le_message']="Affichage des données du profil !";
                    return view('templates/haut2')
                    . view('menu_administrateur',$data)
                    . view('connexion/compte_profil')
                    . view('templates/bas2');
                }    
                $data['titre']="Modification de votre compte !";
                $data['pro'] = $this->model->get_profil($session->get('user'));
                return view('templates/haut2')
                . view('menu_administrateur',$data)
                . view('connexion/modifier_admin')
                . view('templates/bas2');   
            }
            else{
                if ($this->request->getMethod()=="POST"){
                    if (! $this->validate([
                        'prenom' => 'required',
                        'nom' => 'required',
                        'mdp' => 'required|max_length[255]|min_length[8]',
                        'mdp2' => 'required|matches[mdp]',
                        'de' => 'required',
                        'url' => 'required',
                        'bio' => 'required'
                    ],
                    [ // Configuration des messages d’erreurs
                        'prenom' => [
                            'required' => 'Veuillez entrer un prenom pour le compte !',
                        ],
                        'nom' => [
                            'required' => 'Veuillez entrer un nom pour le compte !',
                        ],
                        'mdp' => [
                            'required' => 'Veuillez entrer un mot de passe !',
                            'min_length' => 'Le mot de passe saisi est trop court !',
                        ],
                        'mdp2' => [
                            'required' => 'Veuillez confirmer votre mot de passe !',
                            'matches' => 'Les mots de passes saisis ne sont pas identique !',
                        ],
                        'de' => [
                            'required' => 'Veuillez entrer une discipline pour le compte !',
                        ],
                        'url' => [
                            'required' => 'Veuillez entrer un url pour le compte !',
                        ],
                        'bio' => [
                            'required' => 'Veuillez entrer une biographie pour le compte !',
                        ],
                    ]
                    ))
                    {// La validation du formulaire a échoué, retour au formulaire !
                        $data['titre']="Modification de votre compte !";
                        $data['pro'] = $this->model->get_profil($session->get('user'));
                        return view('templates/haut2')
                        . view('menu_jury',$data)
                        . view('connexion/modifier_jury')
                        . view('templates/bas2');
                    }
                    // La validation du formulaire a réussi, traitement du formulaire
                    $recuperation = $this->validator->getValidated();
                    $this->model->set_profiladmin($recuperation,$session->get('user'));
                    $this->model->set_profiljury($recuperation,$session->get('user'));
                    $data['pro'] = $this->model->get_profil($session->get('user'));
                    $data['le_message']="Affichage des données du profil !";
                    return view('templates/haut2')
                    . view('menu_jury',$data)
                    . view('connexion/compte_profil')
                    . view('templates/bas2');
                }    
                $data['titre']="Modification de votre compte !";
                $data['pro'] = $this->model->get_profil($session->get('user'));
                return view('templates/haut2')
                . view('menu_jury',$data)
                . view('connexion/modifier_jury')
                . view('templates/bas2');
            }
        }
        else{          
            return view('templates/haut', ['titre' => 'Se connecter','t' => ' '],)
                . view('connexion/compte_connecter')
                . view('templates/bas');
        }    
    }

    public function ajouter_c(){
        $session=session();     
        $model = model(Db_model::class);  
        if ($session->has('user')){
           $data['compte'] = $model->get_roleprofil($session->get('user'));

           
           if($data['compte']->r=='A'){
            if ($this->request->getMethod()=="POST"){
                if (! $this->validate([
                    'nom' => 'required',
                    'dd' => 'required',
                    'nbc' => 'required',
                    'nbp' => 'required',
                    'nbs' => 'required',
                    'edition' => 'required',
                    'des' => 'required'
                ],
                [ // Configuration des messages d’erreurs
                    'nom' => [
                        'required' => 'Veuillez entrer un nom pour le concours !',
                    ],
                    'dd' => [
                        'required' => 'Veuillez entrer une date de debut pour le concours !',
                    ],
                    'nbc' => [
                        'required' => 'Veuillez entrer un nombre de jours pour la phase de candidature !',
                    ],
                    'nbp' => [
                        'required' => 'Veuillez entrer un nombre de jours pour la phase de preselection !',
                    ],
                    'nbs' => [
                        'required' => 'Veuillez entrer un nombre de jours pour la phase de selection !',
                    ],
                    'edition' => [
                        'required' => 'Veuillez entrer une edition pour le concours !',
                    ],
                    'des' => [
                        'required' => 'Veuillez entrer une description pour le concours !',
                    ],
                ]
                ))
                {// La validation du formulaire a échoué, retour au formulaire !
                    return view('templates/haut2')
                    . view('menu_administrateur',['t' => ""])
                    . view('connexion/ajouter_concours')
                    . view('templates/bas2');
                }
                // La validation du formulaire a réussi, traitement du formulaire
                if($_POST['dd']<$this->model->get_curdate()->d){
                    return view('templates/haut2')
                    . view('menu_administrateur',['t' => "Veuillez entrer une date postérieur à celle d'aujourd'hui"])
                    . view('connexion/ajouter_concours')
                    . view('templates/bas2');
                }
                $recuperation = $this->validator->getValidated();
                $id=$this->model->get_id_compte($session->get('user'));
                $this->model->set_concours($recuperation,$id->COM_idCompte,"logo.png");
                
                $data['le_message']="Affichage des concours !";
                $data['concours'] = $this->model->get_all_concours();
               
                return view('templates/haut2')
                . view('menu_administrateur',$data)
                . view('connexion/compte_concoursadmin')
                . view('templates/bas2');
            }    
            return view('templates/haut2')
            . view('menu_administrateur',['t' => ''])
            . view('connexion/ajouter_concours')
            . view('templates/bas2');
            }
            else{
                return view('templates/haut2')
                . view('menu_jury')
                . view('connexion/compte_accueil')
                . view('templates/bas2');
            }}
        else{          
            return view('templates/haut')
            . view('menu_visiteur', ['titre' => 'Se connecter','t' => ' '],)
                . view('connexion/compte_connecter')
                . view('templates/bas');
        }    
    } 
    
    public function supprimer_con($id){
        $session=session();
        if ($session->has('user')){
            $data['compte'] = $this->model->get_roleprofil($session->get('user'));
            if($data['compte']->r=='A'){
                $this->model->delete_concours_cat($id);
                $this->model->delete_concours_dis($id);
                $this->model->delete_concours_jug($id);
                $this->model->delete_concours($id);
                $data['le_message']="Affichage des concours !";
                $data['concours'] = $this->model->get_all_concours();
                

                
                
                return view('templates/haut2')
                . view('menu_administrateur',$data)
                . view('connexion/compte_concoursadmin')
                . view('templates/bas2');
            }
            else{
                return view('templates/haut2')
                    .view('menu_jury')
                    .view('connexion/compte_accueil')
                    .view('templates/bas2');
            }
        }
        else{          
            return view('templates/haut', ['titre' => 'Se connecter','t' => ' '],)
                . view('connexion/compte_connecter')
                . view('templates/bas');
        }
        
       

}
}
