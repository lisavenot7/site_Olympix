<div class="container">
<?php $session=session(); 
echo "<h1>";
echo $le_message; 
echo "</h1>";
echo "</br>";
if($pro->JUR_idCompteJury!=NULL){
    $chemin="../../images/".$pro->JUR_image;
    echo "<img height=300px src=$chemin />";
    echo "</br>";
}
echo "</br>";
echo "<h5>Votre identifiant: ";
echo $session->get('user'); 
echo "</br></br>";
echo "Votre nom: ";
echo $pro->COM_nom;
echo "</br></br>";
echo "Votre prénom: ";
echo $pro->COM_prenom;
echo "</br></br>";
echo "Etat de votre profil: ";
if($pro->COM_etat=='A'){
    echo"Activé";
    echo "</br></br>";
}
else{
    echo"Désactivé";
    echo "</br></br>";
}
if($pro->JUR_idCompteJury!=NULL){
    echo"Discipline experte: ";
    echo $pro->JUR_disciplineExperte;
    echo "</br></br>";
    echo"URL: ";
    echo $pro->JUR_url;
    echo "</br></br>";  
    echo"Biographie: ";
    echo $pro->JUR_biographie;
    echo "</br></br>";

}
else{
    echo "</br></br></br></br></br></br></br></br></br>";
}
echo"</h5>";
 ?>
<a href="modifier" ><input  class="btn btn-dark" name="submit" value="Modifier mon profil"></a>

</div>