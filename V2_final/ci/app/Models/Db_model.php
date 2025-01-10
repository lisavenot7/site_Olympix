<?php

namespace App\Models;
use CodeIgniter\Model;

class Db_model extends Model{
    protected $db;

    public function __construct(){
        $this->db = db_connect(); //charger la base de données
            // ou
            // $this->db = \Config\Database::connect();
    }

    //récupération de tous les comptes
    public function get_all_compte(){
        $resultat = $this->db->query("SELECT *, `role`(COM_idCompte) AS r FROM T_COMPTE_COM ORDER BY COM_etat;");
        return $resultat->getResultArray();
    }

    //récupération d'une actualité bien précise
    public function get_actualite($numero){
        $requete="SELECT * FROM T_ACTUALITE_ACT WHERE ACT_idActualite=".$numero.";";
        $resultat = $this->db->query($requete);
        return $resultat->getRow();
    }

    //récupération du nombre de comptes
    public function get_nb_comptes(){
        $requete="SELECT COUNT(COM_idCompte) AS nb_comptes FROM T_COMPTE_COM;";
        $resultat = $this->db->query($requete);
        return $resultat->getRow();
    }

    //Création d'un nouveau compte
    public function set_compte($saisie){
        //Récuparation (+ traitement si nécessaire) des données du formulaire
        $login=$saisie['pseudo'];
        $mot_de_passe=$saisie['mdp'];
        $prenom=$saisie['prenom'];
        $nom=$saisie['nom'];
        $sql="INSERT INTO T_COMPTE_COM VALUES
        (NULL,".$this->db->escape($login).",".$this->db->escape($mot_de_passe).",'D',".
        $this->db->escape($nom).",".$this->db->escape($prenom).");";
        
        return $this->db->query($sql);
    }

    //récupération de toutes les actualités
    public function get_all_actualites(){
        $requete="SELECT * FROM T_ACTUALITE_ACT JOIN T_ADMIN_ADM USING (ADM_idCompteAdmin) JOIN T_COMPTE_COM ON 
        T_ADMIN_ADM.ADM_idCompteAdmin=T_COMPTE_COM.COM_idCompte WHERE ACT_etat='A' ORDER BY ACT_date DESC LIMIT 5;";
        $resultat = $this->db->query($requete);
        return $resultat->getResultArray();
    }
 
    //récupération de tous les concours
    public function get_all_concours(){
        $requete="SELECT CON_nomConcours, CON_idConcours,CON_edition,
		organisateur(CON_idConcours) AS organisateur, 
		phase_actuelle(CON_idConcours) AS phase_actuelle,
		CON_dateDebut, CON_image, CON_description,
        donner_dates(CON_idConcours) AS dates,
        donner_categories(CON_idConcours) AS categorie,
        donner_jury(CON_idConcours) AS juges
        FROM T_CONCOURS_CON 
        GROUP BY CON_idConcours
        ORDER BY phase_actuelle;";
        $resultat = $this->db->query($requete);
        return $resultat->getResultArray();
    }

    //récupération de tous les concours
    public function get_concours_jury($user){
        $requete="SELECT CON_nomConcours, CON_idConcours,
		organisateur(CON_idConcours) AS organisateur, 
		phase_actuelle(CON_idConcours) AS phase_actuelle,
		CON_dateDebut, CON_image, CON_description,
        donner_dates(CON_idConcours) AS dates,
        donner_categories(CON_idConcours) AS categorie,
        donner_jury(CON_idConcours) AS juges
        FROM T_CONCOURS_CON JOIN T_JUGE_JUG USING(CON_idConcours) JOIN T_COMPTE_COM ON JUR_idCompteJury=COM_idCompte
        WHERE COM_identifiant='".$user."'
        GROUP BY CON_idConcours
        ORDER BY phase_actuelle;";
        $resultat = $this->db->query($requete);
        return $resultat->getResultArray();
    }

    //récupération d'une candidature bien précise
    public function get_candidature($code){
        $requete="SELECT * FROM T_CANDIDATURE_CAN 
        JOIN T_CONCOURS_CON USING(CON_idConcours) 
        JOIN T_CATEGORIE_CAT USING(CAT_idCategorie)
        WHERE CAN_codeInscription='".$code."';";
        $resultat = $this->db->query($requete);
        return $resultat->getRow();
    }

    //récupération d'une candidature bien précise
    public function get_can($code,$c){
        $requete="SELECT * FROM T_CANDIDATURE_CAN 
        JOIN T_CONCOURS_CON USING(CON_idConcours) 
        JOIN T_CATEGORIE_CAT USING(CAT_idCategorie)
        WHERE CAN_codeInscription='".$code."' AND CAN_codeCandidat='".$c."';";
        $resultat = $this->db->query($requete);
        if($resultat->getNumRows() > 0){
            return true;}
        else{
            echo "Code(s) erroné(s), aucune candidature trouvée ! ";
         return false;}
    }



    //récupération d'une candidature bien précise
    public function get_documents_candidature($code){
        $requete="SELECT * FROM T_CANDIDATURE_CAN
        JOIN T_DOCUMENT_DOC USING(CAN_idCandidature)
        WHERE CAN_codeInscription='".$code."';";
        $resultat = $this->db->query($requete);
        return $resultat->getResultArray();
    }

    //connexion a un compte    
    public function connect_compte($u,$p){
        $sql="SELECT COM_identifiant,COM_motdepasse,COM_etat FROM T_COMPTE_COM
        WHERE COM_identifiant='".$u."'AND COM_motdepasse=
        SHA2(CONCAT('".$p."','Ceci est mon sel'),256) AND COM_etat='A';";
        $resultat=$this->db->query($sql);
        if($resultat->getNumRows() > 0){
            return true;}
        else{
         return false;}
    }

    //récupération d'un profil bien précis
    public function get_profil($login){
        $requete="SELECT * FROM T_COMPTE_COM LEFT JOIN T_JURY_JUR ON COM_idCompte=JUR_idCompteJury 
        WHERE COM_identifiant='".$login."';";
        $resultat = $this->db->query($requete);
        return $resultat->getRow();
    }

    //récupération d'un role d'un profil bien précis
    public function get_roleprofil($u){
        $requete="SELECT `role`(COM_idCompte) AS r FROM T_COMPTE_COM WHERE COM_idCompte IN (SELECT COM_idCompte FROM T_COMPTE_COM
        WHERE COM_identifiant='".$u."');";
        $resultat = $this->db->query($requete);
        return $resultat->getRow();
    }

    //récupération des candidats preselectionnées d'un concours precis
    public function get_can_preselec($id){
        $requete="SELECT * FROM T_CANDIDATURE_CAN WHERE CON_idConcours=".$id." AND CAN_etat='A' AND CAN_statut='P' ORDER BY CAT_idCategorie;";
        $resultat = $this->db->query($requete);
        return $resultat->getResultArray();
    }

    //récupération des documents des candidats preselectionnées d'un concours precis
    public function get_can_doc_preselec($id){
        $requete="SELECT * FROM T_DOCUMENT_DOC WHERE CAN_idCandidature IN
        (SELECT CAN_idCandidature FROM T_CANDIDATURE_CAN WHERE 
        CON_idConcours=".$id." AND CAN_etat='A' AND CAN_statut='P' ORDER BY CAT_idCategorie);";
        $resultat = $this->db->query($requete);
        return $resultat->getResultArray();
    }

    //récupération de toutes les catégories d'un concours
    public function get_categorie($id){
        $requete="SELECT * FROM T_CONCOURS_CON JOIN T_PARTITIONNEE_PAR USING(CON_idConcours)
        JOIN T_CATEGORIE_CAT USING(CAT_idCategorie) WHERE CON_idConcours=".$id.";";
        $resultat = $this->db->query($requete);
        return $resultat->getResultArray();
    }

    //Modification d'un profil admin
    public function set_profiladmin($saisie,$p){
        //Récuparation (+ traitement si nécessaire) des données du formulaire
        $mot_de_passe=$saisie['mdp'];
        $prenom=$saisie['prenom'];
        $nom=$saisie['nom'];
        $sql="UPDATE T_COMPTE_COM SET COM_prenom=".$this->db->escape($prenom).", COM_nom=".$this->db->escape($nom).",
        COM_motdepasse= SHA2(CONCAT('".$mot_de_passe."','Ceci est mon sel'),256) WHERE COM_identifiant='".$p."';";
        
        return $this->db->query($sql);
    }

    //Modification d'un profil jury
    public function set_profiljury($saisie,$p){
        //Récuparation (+ traitement si nécessaire) des données du formulaire
        $url=$saisie['url'];
        $bio=$saisie['bio'];
        $de=$saisie['de'];
        $sql="UPDATE T_JURY_JUR SET JUR_disciplineExperte=".$this->db->escape($de).", JUR_url=".$this->db->escape($url).",
        JUR_biographie=".$this->db->escape($bio)." WHERE JUR_idCompteJury IN 
        (SELECT JUR_idCompteJury FROM T_JURY_JUR JOIN T_COMPTE_COM ON T_JURY_JUR.JUR_idCompteJury=T_COMPTE_COM.COM_idCompte 
        WHERE COM_identifiant='".$p."');";
        return $this->db->query($sql);
    }

    //Suppression des documents d'une candidature
    public function delete_documents($code){
        $sql="DELETE FROM T_DOCUMENT_DOC WHERE CAN_idCandidature IN (SELECT CAN_idCandidature FROM T_CANDIDATURE_CAN 
        WHERE CAN_codeInscription='".$code."');";
        return $this->db->query($sql);
    }

    //Suppression des notes d'une candidature
    public function delete_notes($code){
        $sql="DELETE FROM T_EVALUE_EVA WHERE CAN_idCandidature IN (SELECT CAN_idCandidature FROM T_CANDIDATURE_CAN 
        WHERE CAN_codeInscription='".$code."');";
        return $this->db->query($sql);
    }

    //Suppression d'une candidature
    public function delete_candidature($code){
        $sql="DELETE FROM T_CANDIDATURE_CAN WHERE CAN_codeInscription='".$code."';";
        return $this->db->query($sql);
    }
    
    //Création d'un nouveau compte 1ère requête
    public function set_compte_1($saisie){
        //Récuparation (+ traitement si nécessaire) des données du formulaire
        $login=$saisie['pseudo'];
        $mot_de_passe=$saisie['mdp'];
        $prenom=$saisie['prenom'];
        $nom=$saisie['nom'];
        $sql="INSERT INTO T_COMPTE_COM VALUES
        (NULL,".$this->db->escape($login).",".$this->db->escape($mot_de_passe).",'A',".
        $this->db->escape($nom).",".$this->db->escape($prenom).");";
        
        return $this->db->query($sql);
    }

    //Création d'un nouveau compte admin 2ère requête
    public function set_compte_admin2($id){
        $sql="INSERT INTO T_ADMIN_ADM VALUES
        (".$id.");";
        
        return $this->db->query($sql);
    }

    //Création d'un nouveau compte admin 2ère requête
    public function set_compte_jury2($de,$url,$bio,$id){
        if($de=" "){$de=NULL;}
        if($url=" "){$url=NULL;}
        if($bio=" "){$bio=NULL;}
        $sql="INSERT INTO T_JURY_JUR VALUES
        (".$id.",".$this->db->escape($de).",".$this->db->escape($url).",".$this->db->escape($bio).",NULL);";
        
        return $this->db->query($sql);
    }

    //Récupération d'un id d'un compte
    public function get_id_compte($p){
        $sql="SELECT COM_idCompte FROM T_COMPTE_COM WHERE COM_identifiant='".$p."';";
        $resultat = $this->db->query($sql);
        return $resultat->getRow();
    }

    //Création d'un nouveau compte admin 1ère requête
    public function set_concours($saisie,$id,$fichier){
        //Récuparation (+ traitement si nécessaire) des données du formulaire
        $nom=$saisie['nom'];
        $dd=$saisie['dd'];
        $nbc=$saisie['nbc'];
        $nbp=$saisie['nbp'];
        $nbs=$saisie['nbs'];
        $edition=$saisie['edition'];
        $des=$saisie['des'];
        $sql="INSERT INTO T_CONCOURS_CON VALUES
        (NULL,".$this->db->escape($nom).",'".$dd."',".$nbc.",
        ".$nbp.",".$nbs.",'".$edition."',".$id.",'".$fichier."',
        ".$this->db->escape($des).");";
        
        return $this->db->query($sql);
    }

    //Suppression des éléments1 rélié à un concours
    public function delete_concours_cat($id){
        $sql="DELETE FROM T_PARTITIONNEE_PAR WHERE CON_idConcours IN 
        (SELECT CON_idConcours FROM T_CONCOURS_CON WHERE CON_idConcours=".$id." AND CON_dateDebut>CURDATE());";
        return $this->db->query($sql);
    }

    //Suppression des éléments2 rélié à un concours
    public function delete_concours_jug($id){
        $sql="DELETE FROM T_JUGE_JUG WHERE CON_idConcours IN 
        (SELECT CON_idConcours FROM T_CONCOURS_CON WHERE CON_idConcours=".$id." AND CON_dateDebut>CURDATE());";
        return $this->db->query($sql);
    }

    //Suppression des éléments2 rélié à un concours
    public function delete_concours_dis($id){
        $sql="DELETE FROM T_DISCUSSION_DIS WHERE CON_idConcours IN 
        (SELECT CON_idConcours FROM T_CONCOURS_CON WHERE CON_idConcours=".$id." AND CON_dateDebut>CURDATE());";
        return $this->db->query($sql);
    }

    //Suppression d'un concours
    public function delete_concours($id){
        $sql="DELETE FROM T_CONCOURS_CON WHERE CON_idConcours=".$id." AND CON_dateDebut>CURDATE();";
        return $this->db->query($sql);
    }

    //Récupération date du jour
    public function get_curdate(){
        $sql="SELECT CURDATE() as d;";
        $resultat = $this->db->query($sql);
        return $resultat->getRow();
    }

}
?>