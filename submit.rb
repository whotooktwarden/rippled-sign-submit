#This ruby script was authored by Taylor Warden to be released free of charge to the community Ripple developers
#Many thanks to julianeon for providing a template Ruby script!!
#Many thanks to JoelKatz for putting up with my stupid syntax/rippled questions!!
#Many thanks to ninobrooks for assisting with unix permission issues!!
#Last Updated on September 16, 2015
#submit.rb and ripple.yml are provided AS-IS and WITHOUT WARRANTY

#Get the input from the command line or an API
$destinationAddress, $destAmount, $destCurrency, $txn_id = ARGV

puts "The arguments passed through were: "
puts $destinationAddress
puts $destAmount
puts $destCurrency
puts $txn_id

#load the requirements to run this script, load the yaml file plus secret, and set rippled's absolute paths
require 'yaml'
require 'json'
ripple=YAML.load_file("/home/ripple.yml")
secret_xagate=ripple["secret"]
#ripple_path="/home/rippled-0.29.0-hf1/build/rippled"
ripple_path="/home/rippled/build/rippled"
conf = "--conf /etc/rippled/rippled.cfg"

puts "Writing #{$txn_id} to completedtxns.out file. "
#Immediately add this transaction ID to the completedtxns.out file
#Please see README.md for more info on this piece of code
open('completedtxns.out', 'a') { |f|
  f.puts "#{$txn_id}"
}

#Get the last closed ledger
cmd2 = `#{ripple_path} #{conf} ledger_closed -q` ;  result=$?.success?
cmder = "#{ripple_path} #{conf} ledger current validated=true"
theMatch = /\"ledger_index\" : [0-9]{8,10}/.match("#{cmd2}")
ledgerCurrent = /[0-9]{8,10}/.match("#{theMatch}")
print "This will end up providing a validated true response. ledger current reports ledger is:  "
print ledgerCurrent

#Get the last ledger sequence (ledgerCurrent plus 3)
stringLedger = ledgerCurrent.to_s
intLVL = stringLedger.to_i + 3

#Get the issuer's account sequence
print ". Getting the account's sequence, "
returnValue = `#{ripple_path} #{conf} account_info rKYHqy2QWbf5WThp7vdJAxTR3WBHKDh9xv #{ledgerCurrent}`
print returnValue
theFullSeq = /\"Sequence" : [0-9]{1,10}/.match("#{returnValue}")
theSeq = /[0-9]{1,10}/.match("#{theFullSeq}")
stringSeq = theSeq.to_s
intSeq = stringSeq.to_i
#Must convert MatchData return to an integer from a string
print " #{intSeq} is the current sequence, "
puts "Validated is true, "
$seqFinal = intSeq

#Form the payment JSON object
$paymentStart = "{\"TransactionType\" : \"Payment\","
$AccountLine = "\"Account\": \"rKYHqy2QWbf5WThp7vdJAxTR3WBHKDh9xv\","
$destinationLine = '"Destination": "'"#{$destinationAddress}"'",'
$FeeLine = '"Fee": "150000",'
$SeqLine = "\"Sequence\": #{$seqFinal},"
lvlLine = "\"LastLedgerSequence\": #{intLVL},"
$AmountStart = "\"Amount\": {"
$currencyLine = '"currency": "'"#{$destCurrency}"'",'
$valueLine = '"value": "'"#{$destAmount}"'",'
$issuerLine = "\"issuer\": \"rKYHqy2QWbf5WThp7vdJAxTR3WBHKDh9xv\""
line = "#{$paymentStart} #{$AccountLine} #{$destinationLine} #{$FeeLine} #{$SeqLine} #{lvlLine} #{$AmountStart} #{$currencyLine} #{$valueLine} #{$issuerLine} }}"
lineJSON = "#{line.to_json}" #convert the line to JSON
#puts "lineJSON: "
#puts "#{lineJSON}"

#Build the sign command
cmd2=`#{ripple_path} #{conf} sign #{secret_xagate} #{lineJSON} offline`
cmder="#{ripple_path} #{conf} sign #{secret_xagate} #{lineJSON} offline"
#Run the command by specifying the pass, sign the txn, parse the payment JSON, do not validate the transaction
puts "Sign Command about to run, "
system("#{cmder}")
#This system command returns a blob in binary to submit

#match the tx blob response
theMatch = /\"tx_blob\" : "[A-Z0-9]{100,}\"/.match("#{cmd2}")
#puts "theMatch: #{theMatch}"
#Match just the blob
blob = /[A-Z0-9]{100,}/.match("#{theMatch}")
puts "The blob to submit is #{blob}, "
#blob = %x[cmder]

theMatch = /\"SigningPubKey\" : \"[A-Z0-9]{66,}/.match("#{cmd2}")
#puts "theMatch: #{theMatch}"
#Match just the spk
signingPK = /([A-Z0-9]{66,})/.match("#{theMatch}")
puts "The SigningPubKey #{signingPK}, "

theMatch = /\"TxnSignature\" : \"[A-Z0-9]{1,142}/.match("#{cmd2}")
#puts "theMatch: #{theMatch}"
#Match just the signature 
theSig = /([A-Z0-9]{140,})/.match("#{theMatch}")
puts "The TxnSignature is #{theSig}, "

#form the submit command
blob_submit ="#{ripple_path} #{conf} submit #{blob}"

#Submit the transaction
system("#{blob_submit}")

#Get a new last validated ledger
cmd2 = `#{ripple_path} #{conf} ledger_closed -q` ;  result=$?.success?
cmder = "#{ripple_path} #{conf} ledger current validated=true"
theMatch = /\"ledger_index\" : [0-9]{8,10}/.match("#{cmd2}")
newLVL = /[0-9]{8,10}/.match("#{theMatch}")
print "This will end up providing a validated true response. The last validated ledger is:"
print "#{newLVL}, "

#Get the last ledger sequence, the LVL + 3
firstLLS = "#{newLVL.to_s}"
theLLS = firstLLS.to_i + 3
print "The last ledger sequence is #{theLLS}, "

#Get the account's sequence again
print "Getting the account's sequence, "
returnVal = `#{ripple_path} #{conf} account_info rKYHqy2QWbf5WThp7vdJAxTR3WBHKDh9xv #{newLVL}`
print returnVal
theFullSeq = /\"Sequence" : [0-9]{1,10}/.match("#{returnVal}")
theSeq = /[0-9]{1,10}/.match("#{theFullSeq}")
stringSeq = theSeq.to_s
newSeq = stringSeq.to_i
#Warn that this sequence may increase soon
print "#{newSeq} is the current sequence and it may increment soon! "
puts "Validated is true, "

#This currently has a syntax error somewhere...
#place this account set txn block within the proper cases when prepared

accountStart = "\"TransactionType\" : \"AccountSet\","
$AccountLine = "\"Account\": \"rKYHqy2QWbf5WThp7vdJAxTR3WBHKDh9xv\","
$FeeLine = '"Fee": "150000",'
$SeqLine = "\"Sequence\": #{newSeq},"
lvlLine = "\"LastLedgerSequence\": #{theLLS},"
flagsLine = '"Flags": 2147483648,'
spkLine = "\"SigningPublicKey\": #{signingPK},"
sigLine =  "\"TxnSignature\": #{theSig}"
setLine = "{#{accountStart} #{$AccountLine} #{$FeeLine} #{$SeqLine} #{lvlLine} #{flagsLine} #{spkLine} #{sigLine}}"
linetoJSON = "#{setLine.to_json}"
#puts "linetoJSON: #{linetoJSON} "
#puts "setLine: #{setLine} "
#accountSetCmd=`#{ripple_path} #{conf} json #{linetoJSON}`#uncomment when working
#accountSetCmder="#{ripple_path} #{conf} json #{linetoJSON}"#uncomment when working
#puts "Command to run: #{accountSetCmder}"
#puts "AccountSet Command about to run: #{accountSetCmd}"
#system("#{accountSetCmder}")#uncomment when working
#print accountSetCmd

#set the ledger values to the correct data type
ledgerCurrent = ledgerCurrent.to_s
theLLS = theLLS.to_s

ledgerCurrent = ledgerCurrent.to_i
theLLS = stringLedger.to_i

#for reference the ledgers are:
#oldledger = ledgerCurrent
#newLedger = theLLS

#Display the ledger indexes
puts "The ledger index: "
puts ledgerCurrent
puts "The transaction should succeed or fail by Ledger: "
puts theLLS + 3

#If currentLedger and newLVL are equal, wait for 3 rounds of consensus by sleeping for 15 seconds, do an accountset txn
if ledgerCurrent == theLLS
puts "The ledger indexes are equal: #{ledgerCurrent} == NewLVL: #{theLLS}.  Waiting 15 seconds for consensus. "
sleep 15
#puts "An AccountSet should be done now! "
#paste the above accountset block here when functioning
#If the newLVL is less than the currentLedger, keep waiting for a few rounds of consensus by sleeping for 30 seconds, do an accountset txn
elsif theLLS < ledgerCurrent
puts "The newest reported LVL was #{theLLS} and it is less than the ledgerCurrent value of #{ledgerCurrent}.  Waiting 30 seconds for consensus. "
sleep 30
#puts "An AccountSet should be done now! "
#paste the above accountset block here when functioning
#if the currentLedger is greater than or equal to the newLVL, then the transaction failed, do an accountset txn
elsif ledgerCurrent >= theLLS
puts "currentLedger: #{ledgerCurrent} >= NewLVL: #{theLLS}. "
#puts "An AccountSet should be done now! "
#paste the above accountset block here when functioning
end
