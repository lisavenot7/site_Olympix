<div class="container">

<h1><?php echo $titre; ?></h1>

<?= session()->getFlashdata('error') ?>

</br>
<?php
// Création d’un formulaire qui pointe vers l’URL de base + /compte/creer
echo form_open('/compte/modifier'); ?>
<?= csrf_field() ?>
<h5>
<label for="prenom">Prénom : </label>
<?php
echo "<input type='input' style='width:394px;' name='prenom' value=' $pro->COM_prenom'>";
?>
</br>

</br>
<label for="nom">Nom : </label>
<?php
echo "<input type='input' style='width:420px;' name='nom' value='$pro->COM_nom'>";
?>
</br>

</br>
<label for="nom">Discipline Experte : </label>
<?php
echo "<input type='input' style='width:305px;' name='de' value='$pro->JUR_disciplineExperte'>";
?>
</br>

</br>
<label for="nom">URL : </label>
<?php
echo "<input type='input' style='width:428px;' name='url' value='$pro->JUR_url'>";
?>
</br>

</br>
<label for="nom">Biographie : </label>
<?php
echo " <textarea class='form-control' style='width:478px;height: 300px;' name='bio' >$pro->JUR_biographie</textarea>";
?>
</br>

</br>
<label for="mdp">Mot de passe : </label>
<input type="password" style="width:347px;" name="mdp" value="">
</br>
</br>
<label for="mdp2"> Validation du mot de passe : </label>
<input type="password" style="width:226px;" name="mdp2" value="">
</br>


</br>
<input type="submit" class="btn btn-dark btn-lg btn-block" name="submit" value="Valider"></br></br>
<a href="afficher_profil"><input type="button" class="btn btn-dark btn-lg btn-block" name="submit" value="Annuler"></a>
</br>
<?= validation_show_error('prenom') ?>
</br>
<?= validation_show_error('nom') ?>
</br>
<?= validation_show_error('mdp') ?>
</br>
<?= validation_show_error('mdp2') ?>
</br>
<?= validation_show_error('de') ?>
</br>
<?= validation_show_error('url') ?>
</br>
<?= validation_show_error('bio') ?>
</br>
</h5>

</div>