<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Registration_Email</fullName>
        <ccEmails>dummy@gbhem.org</ccEmails>
        <description>Registration Email</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Pastrol_email</template>
    </alerts>
    <rules>
        <fullName>Pastrol_Acts_Email alert</fullName>
        <actions>
            <name>Registration_Email</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Pastoral_Acts__c.OwnerId</field>
            <operation>notEqual</operation>
            <value>-9</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
