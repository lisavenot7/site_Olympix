

<div class="container">
<h1 ><?php echo $titre; ?></h1>
</br><?php echo $t; ?></br></br>
<a href="ajouter_comptes"><input type="button" class="btn btn-dark btn-lg btn-block" name="submit" value="Ajouter un compte"></a></br></br>
<?php
if (! empty($logins) && is_array($logins)){ 
    
    echo "<table class='table table-hover '>";
    echo"<thead>";
    echo"<tr>";
      echo"<th scope='col'>Identifiant</th>";
      echo"<th scope='col'>Nom</th>";
      echo"<th scope='col'>prenom</th>";
      echo"<th scope='col'>Etat</th>";
      echo"<th scope='col'>Role</th>";
      echo"<th scope='col'></th><th scope='col'></th>";
    echo"</tr>";
    echo"</thead>";

    echo"<tbody>";
        foreach ($logins as $pseudos){
            echo"<tr>";
            echo "<td>";
            echo $pseudos["COM_identifiant"];
            echo "</td>";
            echo "<td>";
            echo $pseudos["COM_nom"];
            echo "</td>";
            echo "<td>";
            echo $pseudos["COM_prenom"];
            echo "</td>";
            echo "<td>";
            if($pseudos["COM_etat"]=='A'){echo "Activé";}
            else{echo "Désactivé";}
            echo "</td>";
            echo "<td>";
            if($pseudos["r"]=='A'){echo"Administrateur";}
            elseif($pseudos["r"]=='J'){echo"Membre du jury";}
            echo "</td>";
            echo "<td>";
            if($pseudos["COM_idCompte"]!=1 && $pseudos['COM_etat']=='A'){echo "<a href='desactiver' ><input  class='btn btn-dark' name='submit' value='Désactiver'></a>";}
            if($pseudos["COM_idCompte"]!=1 && $pseudos['COM_etat']=='D'){echo "<a href='activer' ><input  class='btn btn-dark' name='submit' value='Activer'></a>";}
            echo "</td>";
            echo "<td>";
            if($pseudos["COM_idCompte"]!=1){echo "<a href='about.html'><i class='fas fa-trash-alt text-dark' style='font-size:30px'></i></a>";}
            echo "</td>";
            echo"</tr>";
        }
  echo"</tbody>";
echo"</table>"; 
echo"</br>";
}
else {
    echo("<h3>Aucun compte pour le moment</h3>");
}

?>




</div>