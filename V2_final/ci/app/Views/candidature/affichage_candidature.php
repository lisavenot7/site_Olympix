


<section class="page-section">
    <div class="container">
        <?php
            if (isset($can)){
                echo"<div class='product-item'>";
                
                    echo"<h1 class='text-white mb4' >";
                        echo"AFFICHAGE DE VOTRE CANDIDATURE";
                    echo"</h1>";
                    echo "</br></br>";
                    echo"<div class='product-item-description d-flex me-auto'>";
                        echo"<div class='bg-faded p-5 rounded'>";
                            echo"<h3>";
                            echo "<strong>Votre prénom: </strong>";
                            echo $can->CAN_prenomCandidat;
                            echo"</br>";
                            echo "<strong>Votre nom:  </strong>";
                            echo $can->CAN_nomCandidat;
                            echo"</br>";
                            echo "<strong>Votre code d'inscription:  </strong>";
                            echo $can->CAN_codeInscription;
                            echo"</br>";
                            echo "<strong>Votre code de candidat:  </strong>";
                            echo $can->CAN_codeCandidat;
                            echo"</br>";
                            echo "<strong>Concours participé:  </strong>";
                            echo $can->CON_nomConcours;
                            echo"</br>";
                            echo "<strong>Catégorie:  </strong>";
                            echo $can->CAT_nomCategorie;
                            echo"</br>";
                            echo "<strong>Etat de votre candidature:  </strong>";
                            if($can->CAN_etat='A'){echo "Activé";}
                            else{echo "Désactivé";}
                            echo"</br></br>";
                            $chemin='supprimer/'.$can->CAN_codeInscription.'/'.$can->CAN_codeCandidat;
                            echo"<a href=$chemin><input type='button' class='btn btn-dark btn-lg btn-block'  value='Supprimer ma candidature'></a>";
                            echo"</h3>";
                        echo"</div>";
                    echo"</div>";
                    echo "</br></br>";
                    if (! empty($docs)){ 
                        echo "<table><th>";
                        foreach ($docs as $d){
                            echo"<td>";
                            $chemin="https://obiwan.univ-brest.fr/~e22200744/documents/".$d['DOC_nomDocument'];
                            echo "<img height=300px src=$chemin />";
                            echo"</td>";
                            echo"<td></td>";
                        }
                        echo"</th></table>";
                       
                    }
                    else {
                        echo("<h3 class='text-white mb4'>Aucun documents pour cette candidature</h3>");
                    }
                echo"<h1 class='text-white mb4' >";
                echo $t;
                echo"</h1>";
                echo"</div>";
            }
            else{
                echo"<div class='product-item'>";
                    echo"<div class='product-item-title d-flex'>";
                        echo"<div class='bg-faded p-5 d-flex ms-auto rounded'>";
                            echo"<h2 class='section-heading mb-0'>";
                                echo"<span class='section-heading-lower' style='text-align:center;'>";
                                    echo"AUCUNE CANDIDATURE NE POSSEDE CE CODE D'INSCRIPTION";
                                echo"</span>";
                            echo"</h2>";
                       echo"</div>";
                    echo"</div>";
                    echo "</br></br></br></br></br></br></br></br></br></br></br></br></br></br>";
                echo"</div>";
            }
        ?>
    </div>
</section>
