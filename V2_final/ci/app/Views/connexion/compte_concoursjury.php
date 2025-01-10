<div class="container">
</br>
<h1 >AFFICHAGE DES CONCOURS</h1>
</br>
<?php 

    if (! empty($concours) && is_array($concours)){
        echo"<table class='table table-hover '>
        <thead>
        <tr>
        <th scope='col'></th>
        <th scope='col'>NOM DU CONCOURS</th>
        <th scope='col'>PHASE ACTUELLE</th>
        <th scope='col'>DATES IMPORTANTES</th>
        <th scope='col'>CATEGORIES</th>
        <th scope='col'></th>
        </tr>
        </thead>
        <tbody>";
        foreach ($concours as $cnc){
            echo "<tr>";
            echo "<th>";
            $logo="../../bootstrap/assets/img/".$cnc["CON_image"];
            echo "<img src='".$logo."' height=80px/>";
            echo "</th> ";
            echo "<th>";
            echo $cnc["CON_nomConcours"];
            echo "</th> ";
            echo "<th>";
            echo $cnc["phase_actuelle"];
            echo "</th> ";
            echo "<th>";
            echo $cnc["CON_dateDebut"];
            echo"</br>";
            echo $cnc["dates"];
            echo "</th> ";
            echo "<th>";
            if($cnc["categorie"]!=""){
                echo $cnc["categorie"];}
            else{
                echo "Aucune catégories";
            }
            echo "</th> ";
            echo "<th>";
            
            if($cnc["phase_actuelle"]=="sélection"){
                $chemin="c_preselection/".$cnc["CON_idConcours"];
                 echo "<a href=$chemin><i class='fa fa-users text-dark' style='font-size:30px'></i></a>";}
            
            echo "</th>";
            echo "</tr>";
        }
        echo"</tbody></table>";
        echo "</br></br></br></br></br></br></br></br></br></br></br>";
    }
    else{
        echo "<h2 >";
        echo " Aucun concours pour le moment";
        echo "</h2>";
        echo "</br></br></br></br></br></br></br></br></br></br></br></br></br></br></br></br>";
    }

?> 
</div>  
</br>