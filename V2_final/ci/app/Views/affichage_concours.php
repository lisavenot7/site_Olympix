<div class="container">
</br>
<h1 class="text-white mb4" >AFFICHAGE DES CONCOURS</h1>
</br>
<?php 

    if (! empty($concours) && is_array($concours)){
        echo"<table class='table table-hover table-dark '>
        <thead>
        <tr>
        <th scope='col'></th>
        <th scope='col'>NOM DU CONCOURS</th>
        <th scope='col'>DESCRIPTION</th>
        <th scope='col'>PHASE ACTUELLE</th>
        <th scope='col'>DATES IMPORTANTES</th>
        <th scope='col'>CATEGORIES</th>
        <th scope='col'>MEMBRES DU JURYS</th>
        <th scope='col'>ORGANISATEUR</th>
        <th scope='col'></th>
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
            echo $cnc["CON_description"];
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
            if($cnc["juges"]!=""){
                echo $cnc["juges"];}
            else{
                echo "Aucun membre du jury";
            }
            echo "</th> ";
            echo "<th>";
            echo $cnc["organisateur"];
            echo "</th> ";
            echo "<th>";
            echo "<a href='about.html'><i class='fas fa-search text-light' style='font-size:30px'></i></a>";
            echo "</th>";
            echo "<th>";
            if($cnc["phase_actuelle"]=="inscriptions"){
                echo "<a href='about.html'><i class='fas fa-edit text-sucess' style='font-size:30px'></i></a>";}
            else if($cnc["phase_actuelle"]=="sélection"){
                $chemin='c_preselection/'.$cnc["CON_idConcours"];
                 echo "<a href=$chemin><i class='fa fa-users text-info' style='font-size:30px'></i></a>";}
            else if($cnc["phase_actuelle"]=="terminé"){
                echo "<a href='about.html'><i class='fas fa-trophy text-warning' style='font-size:30px'></i></a>";}
            echo "</th>";
            echo "</tr>";
        }
        echo"</tbody></table>";
    }
    else{
        echo "<h2 class='text-white-50 mx-auto mt-2 mb-5'>";
        echo " Aucun concours pour le moment";
        echo "</h2>";
    }

?> 
</div>  
</br>
