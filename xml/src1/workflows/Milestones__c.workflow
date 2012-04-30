<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>MilestoneUniqueBirth</fullName>
        <description>Birth Date for contact should be Unique</description>
        <field>UniqueBirth__c</field>
        <formula>Contact__c +  TEXT(Milestone__c)</formula>
        <name>MilestoneUniqueBirth</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MilestoneUniqueDeath</fullName>
        <description>Milestone Unique Death for Contact</description>
        <field>UniqueDeath__c</field>
        <formula>Contact__c + TEXT(Milestone__c)</formula>
        <name>MilestoneUniqueDeath</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>MilestoneUniqueBirth</fullName>
        <actions>
            <name>MilestoneUniqueBirth</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Milestones__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Birth Date</value>
        </criteriaItems>
        <criteriaItems>
            <field>Milestones__c.Milestone__c</field>
            <operation>equals</operation>
            <value>Birth Date</value>
        </criteriaItems>
        <description>Birth Date Milestone should be Unique</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>MilestoneUniqueDeath</fullName>
        <actions>
            <name>MilestoneUniqueDeath</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Milestones__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Death Date</value>
        </criteriaItems>
        <criteriaItems>
            <field>Milestones__c.Milestone__c</field>
            <operation>equals</operation>
            <value>Death Date</value>
        </criteriaItems>
        <description>Death Date should be Unique for contact</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
