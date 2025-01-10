<div class="container">
</br>
<h1>Ajouter un concours</h1>

<?= session()->getFlashdata('error') ?>

</br>
<?php
// Création d’un formulaire qui pointe vers l’URL de base + /compte/creer
echo form_open('/compte/ajouter_concours'); ?>
<?= csrf_field() ?>
<h5>
<label for="prenom">Nom du concours: </label>
<input type='input' style='width:280px;' name='nom' value=''>
</br>

</br>
<label for="nom">Date du début du concours : </label>
<input type='date' style='width:195px;' name='dd' value=''>
</br>

</br>
<label for="nom">Nombre de jours pour candidater : </label>
<input type='input' style='width:140px;' name='nbc' value=''>
</br>

</br>
<label for="nom">Nombre de jours pour la preselection : </label>
<input type='input' style='width:105px;' name='nbp' value=''>
</br>

</br>
<label for="nom">Nombre de jours pour la selection : </label>
<input type='input' style='width:135px;' name='nbs' value=''>
</br>

</br>
<label for="nom">Edition : </label>
<input type='input' style='width:370px;' name='edition' value=''>
</br>

</br>
<label for="nom">Description : </label>
<textarea class='form-control' style='width:450px;height: 300px;' name='des' ></textarea>
</br>


</br>
<input type="submit" class="btn btn-dark btn-lg btn-block" name="submit" value="Valider"></br></br>
</br>
<?= validation_show_error('nom') ?>
</br>
<?= validation_show_error('dd') ?>
</br>
<?= validation_show_error('nbc') ?>
</br>
<?= validation_show_error('nbp') ?>
</br>
<?= validation_show_error('nbs') ?>
</br>
<?= validation_show_error('edition') ?>
</br>
<?= validation_show_error('des') ?>
</br>
</h5>
<?php echo $t ?>
</div>