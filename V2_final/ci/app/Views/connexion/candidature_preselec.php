<div class="container">
<?php 

if (! empty($cat) && is_array($cat)){
    echo"</br><h1>Candidats présélectionnées pour ce concours :</h1></br>";
    echo "<div class='product-item'>";echo "<div class='text-center'>";
    foreach ($cat as $ca){
        echo"</br><h1  >";
        echo($ca['CAT_nomCategorie']);
        echo "</h1></br>";
        echo"<div class='row gx-4 gx-lg-5'>";
        
        if (! empty($can) && is_array($can)){

            foreach ($can as $c){
                if($c['CAT_idCategorie']==$ca['CAT_idCategorie']){


                    echo("<div class='col-4'>");
                    echo"<div class='card' style='heigth: 600px;'>";
                               
                    echo"<div class='card-body text-center'>";
                    if (! empty($docs)){ 
                        echo "<table><th>";
                        foreach ($docs as $d){
                            if($d['CAN_idCandidature']==$c['CAN_idCandidature']){
                            echo"<td>";
                            $chemin="https://obiwan.univ-brest.fr/~e22200744/documents/".$d['DOC_nomDocument'];
                            echo "<img style='height: 7rem;' src=$chemin />";
                            echo"</td>";}
                        }
                        echo"</th></table>";
                       
                    }
                    else {
                        echo("<h3 class='text-white mb4'>Aucun documents pour cette candidature</h3>");
                    }
                    echo("<div class='small text-black-50' style='font-size: 20px;'>");
                    echo "<h5>";
                    echo($c['CAN_nomCandidat']);
                    echo " ";
                    echo($c['CAN_prenomCandidat']);
                    echo "</h5>";
                    echo"</div>";
                                
                    echo"</div>";
                                
                    echo"</div>";
                    echo"</div>";






                }
            }
            echo "</br>";
        }
        else{
            echo "<h2>";
            echo " Aucune candidature présélectionnée ";
            echo "</h2>";
        } 
        echo "</div>";
        echo "";
        echo "</br></br>";
    }
    echo "</div></div>";
    
}
else{
    echo "<h2>";
    echo " Aucune catégorie pour ce concours ou ce concours n'existe pas";
    echo "</h2>";
    echo "</br></br></br></br></br></br></br></br></br></br></br></br></br></br></br></br>";
}


?> 

</div>